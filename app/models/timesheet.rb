class Timesheet < ActiveRecord::Base
  belongs_to :user
  has_many :projects_timesheets, ->{ order('projects_timesheets.created_at') }
  has_many :projects, ->{ order('special_type desc nulls first') }, :through => :projects_timesheets
  has_many :entries, :through => :projects_timesheets

  accepts_nested_attributes_for :projects, :allow_destroy => true
  accepts_nested_attributes_for :projects_timesheets
  accepts_nested_attributes_for :entries

  validate :presence_of_projects_timesheets_notes, :if => :ready_to_invoice?

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

  def previous_timesheet
    self.class.find_by(params = week.previous.ymd_hash.merge(:user => user))
  end

  def previous_timesheets_projects
    return [] unless timesheet = previous_timesheet
    timesheet.projects
  end

  def projects_timesheet_for(project)
    projects_timesheets.find { |pt| pt.project == project }
  end

  def entries_for(project)
    projects_timesheet_for(project).find_or_create_entries!
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

  def presence_of_projects_timesheets_notes
    projects_timesheets.
      select {|pt| pt.project.requires_notes? && pt.notes.blank? }.each do |pt|
        errors.add(:required_summary_notes, "are missing for the '#{pt.project.name}' project")
      end
  end
end
