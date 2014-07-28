class CreateProjectsTimesheets < ActiveRecord::Migration
  def change
    create_table :projects_timesheets do |t|
      t.references :project, :index => true
      t.references :timesheet, :index => true
    end
  end
end
