class AddTimestampsToProjectsAndProjectTimesheets < ActiveRecord::Migration
  def change
    add_timestamps(:projects)
    add_timestamps(:projects_timesheets)
  end
end
