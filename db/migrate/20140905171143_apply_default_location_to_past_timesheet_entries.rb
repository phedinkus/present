class ApplyDefaultLocationToPastTimesheetEntries < ActiveRecord::Migration
  class MigrationUser < ActiveRecord::Base
    self.table_name = :users
    belongs_to :location, :class_name => "ApplyDefaultLocationToPastTimesheetEntries::MigrationLocation"
    has_many :timesheets, :class_name => "ApplyDefaultLocationToPastTimesheetEntries::MigrationTimesheet"
  end

  class MigrationTimesheet < ActiveRecord::Base
    self.table_name = :timesheets
    belongs_to :user, :class_name => "ApplyDefaultLocationToPastTimesheetEntries::MigrationUser"
    has_many :projects_timesheets, :class_name => "ApplyDefaultLocationToPastTimesheetEntries::MigrationProjectsTimesheet"
  end

  class MigrationProjectsTimesheet < ActiveRecord::Base
    self.table_name = :projects_timesheets
    belongs_to :timesheet, :class_name => "ApplyDefaultLocationToPastTimesheetEntries::MigrationTimesheet"
    has_many :entries, :class_name => "ApplyDefaultLocationToPastTimesheetEntries::MigrationEntry"
  end

  class MigrationEntry < ActiveRecord::Base
    self.table_name = :entries
    belongs_to :projects_timesheet, :class_name => "ApplyDefaultLocationToPastTimesheetEntries::MigrationProjectsTimesheet"
    has_one :timesheet, :through => :projects_timesheet

  end

  class MigrationLocation < ActiveRecord::Base
    self.table_name = :locations
  end

  def up
    MigrationUser.all.each do |user|
      MigrationEntry.
        joins(:timesheet => :user).
        where("timesheets.user_id" => user).
        update_all(:location_id => user.location_id)
    end
  end

  def down
    # do nothing, just a data migration
  end
end
