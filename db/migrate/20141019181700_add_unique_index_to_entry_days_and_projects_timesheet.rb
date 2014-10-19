class AddUniqueIndexToEntryDaysAndProjectsTimesheet < ActiveRecord::Migration
  def change
    add_index :entries, [:projects_timesheet_id, :day], unique: true
  end
end
