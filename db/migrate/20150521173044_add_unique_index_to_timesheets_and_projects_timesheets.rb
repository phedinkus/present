class AddUniqueIndexToTimesheetsAndProjectsTimesheets < ActiveRecord::Migration
  def change
    add_index :timesheets, [:user_id, :year, :month, :day], :unique => true
    add_index :projects_timesheets, [:timesheet_id, :project_id], :unique => true
  end
end
