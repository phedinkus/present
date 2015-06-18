require "test_helper"

class LineItemsTest < ActiveSupport::TestCase
  def setup
    @subject = Present::Harvest::LineItems
    @project = projects(:sea_lab)
    @entries = [:one_sea_lab, :two_sea_lab].map {|pt| projects_timesheets(pt).entries }.flatten
  end

  test ".generate" do
    @results = @subject.generate(@project, @entries)

    assert_equal 1, @results.size
  end
end
