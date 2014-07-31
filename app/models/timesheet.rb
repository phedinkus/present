class Timesheet < ActiveRecord::Base
  belongs_to :user
  has_many :projects_timesheets, ->{ order(:created_at) }
  has_many :projects, :through => :projects_timesheets
  has_many :entries, :through => :projects_timesheets

  accepts_nested_attributes_for :projects, :allow_destroy => true
  accepts_nested_attributes_for :entries

  def self.find_or_create_for!(week, user)
    find_or_create_by!(week.ymd_hash.merge(:user => user))
  end
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
end
