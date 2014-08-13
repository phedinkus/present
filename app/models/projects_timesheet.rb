class ProjectsTimesheet < ActiveRecord::Base
  belongs_to :project
  belongs_to :timesheet
  has_many :entries, :dependent => :destroy

  def self.for_week_and_project(week, project)
    joins(:timesheet).where(
      "timesheets.year" => week.year,
      "timesheets.month" => week.month,
      "timesheets.day" => week.day,
      "projects_timesheets.project_id" => project
    )
  end

  def self.outdated_in_harvest
    joins(:timesheet, :project, :entries).uniq.where <<-SQL
      projects_timesheets.sent_to_harvest_at is null
      OR
      projects_timesheets.updated_at > projects_timesheets.sent_to_harvest_at
      OR
      timesheets.updated_at > projects_timesheets.sent_to_harvest_at
      OR
      entries.updated_at > projects_timesheets.sent_to_harvest_at
    SQL
  end

  def find_or_create_entries!
    Entry.days.map do |(name, ordinal)|
      Entry.find_or_create_by!(
        :projects_timesheet => self,
        :day => ordinal
      )
    end
  end
end
