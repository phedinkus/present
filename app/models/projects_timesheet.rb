class ProjectsTimesheet < ActiveRecord::Base
  belongs_to :project
  belongs_to :timesheet
  has_many :entries, :dependent => :destroy

  def self.for(project, timesheets)
    where(:project => project, :timesheet => timesheets)
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
