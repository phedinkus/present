class Timesheet < ActiveRecord::Base
  belongs_to :user
  has_many :projects_timesheets, ->{ order('projects_timesheets.created_at') }
  has_many :projects, ->{ order('special_type desc nulls first') }, :through => :projects_timesheets
  has_many :entries, :through => :projects_timesheets

  accepts_nested_attributes_for :projects, :allow_destroy => true
  accepts_nested_attributes_for :entries

  def self.find_or_create_for!(week, user)
    if existing = find_by(params = week.ymd_hash.merge(:user => user))
      existing
    else
      Timesheet.new(params).tap do |timesheet|
        timesheet.projects += Project.all.select(&:sticky?)
        timesheet.projects += timesheet.previous_timesheets_projects
        timesheet.save!
      end
    end
  end

  def self.current_and_past
    where("DATE(timesheets.year||'-'||timesheets.month||'-'||timesheets.day) < now()")
  end

  def self.future
    where("DATE(timesheets.year||'-'||timesheets.month||'-'||timesheets.day) > now()")
  end

  def previous_timesheets_projects
    return [] unless timesheet = self.class.find_by(params = week.previous.ymd_hash.merge(:user => user))
    timesheet.projects
  end

  def entries_for(project)
    projects_timesheets.find { |pt| pt.project == project }.find_or_create_entries!
  end

  def week
    Week.for(year, month, day)
  end

  def time
    Time.zone.local(year, month, day)
  end

  def empty?
    entries.all?(&:zero?)
  end

  def non_empty_weekend_entries?
    entries.select(&:weekend?).any?(&:nonzero?)
  end
end
