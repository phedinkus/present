require 'test_helper'

class TimesheetTest < ActiveSupport::TestCase
  include WeeksHelper

  def test_find_or_build_for!
    user = User.new
    @current_user = user
    week = Week.now
    timesheet = Timesheet.find_or_build_for!(Week.now, user)
    assert_predicate timesheet.projects_timesheets, :any?
    assert timesheet.projects_timesheets.first.timesheet
    projects = sort_projects(timesheet)
    projects.each { |proj|
      timesheet.entries_for timesheet.projects_timesheet_for(proj)
    }
  end
end
