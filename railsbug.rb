require 'active_record'

ActiveRecord::Base.establish_connection adapter: 'sqlite3', database: ':memory:'
ActiveRecord::Base.connection.instance_eval do
  create_table "timesheets" do |t|
  end

  create_table "projects_timesheets" do |t|
    t.integer  "project_id"
    t.integer  "timesheet_id"
  end

  create_table "projects" do |t|
  end
end

class Project < ActiveRecord::Base
  has_many :projects_timesheets
  has_many :entries, :through => :projects_timesheets
end

class ProjectsTimesheet < ActiveRecord::Base
  belongs_to :project
  belongs_to :timesheet
end

class Timesheet < ActiveRecord::Base
  has_many :projects_timesheets
  has_many :projects, :through => :projects_timesheets

  accepts_nested_attributes_for :projects_timesheets
end

timesheet = Timesheet.new.tap do |timesheet|
  timesheet.projects += [Project.new]
end

p timesheet.projects_timesheets.first.timesheet
