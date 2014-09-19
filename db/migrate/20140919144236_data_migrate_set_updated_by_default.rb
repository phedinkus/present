class DataMigrateSetUpdatedByDefault < ActiveRecord::Migration
  class MigrationUser < ActiveRecord::Base
    self.table_name = :users
  end

  class MigrationTimesheet < ActiveRecord::Base
    self.table_name = :timesheets
    belongs_to :user, :class_name => "DataMigrateSetUpdatedByDefault::MigrationUser"
    has_many :projects_timesheets, :class_name => "DataMigrateSetUpdatedByDefault::MigrationProjectsTimesheet"
  end

  class MigrationProjectsTimesheet < ActiveRecord::Base
    self.table_name = :projects_timesheets
    belongs_to :timesheet, :class_name => "DataMigrateSetUpdatedByDefault::MigrationTimesheet"
    has_many :entries, :class_name => "DataMigrateSetUpdatedByDefault::MigrationEntry"
  end

  class MigrationEntry < ActiveRecord::Base
    self.table_name = :entries
    belongs_to :projects_timesheet, :class_name => "DataMigrateSetUpdatedByDefault::MigrationProjectsTimesheet"
    belongs_to :user, :class_name => "DataMigrateSetUpdatedByDefault::MigrationUser"
  end

  def up
    MigrationEntry.find_each do |entry|
      entry.update!(:updated_by_id => entry.projects_timesheet.timesheet.user_id)
    end
  end

  def down

  end
end
