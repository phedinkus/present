require "test_helper"

class LineItemsTest < ActiveSupport::TestCase
  def arrange
    @subject = Present::Harvest::LineItems
    @project = projects(:sea_lab)
    @entries = [:one_sea_lab, :two_sea_lab].map { |pt|
      projects_timesheets(pt).entries
    }.flatten
  end

  def act
    @subject.generate(@project, @entries)
  end

  test "defaults to a single row of two full weeks" do
    arrange

    results = act

    assert_equal results, [{
      :kind=> "Service",
      :quantity=> 2.0,
      :unit_price=> @project.weekly_rate,
      :description=> "Sterling Mallory Archer\n\n(10.0/10.0 days worked)\n"
    }]
  end

  test "deducts absent day and reports absence" do
    entries(:one_sea_lab_tuesday).absent!
    arrange

    results = act

    assert_equal results, [{
      :kind=> "Service",
      :quantity=> 1.8,
      :unit_price=> @project.weekly_rate,
      :description=> "Sterling Mallory Archer\n\n(9.0/10.0 days worked)\nAbsent on 6/2\n"
    }]
  end

  test "adds weekend day and reports it" do
    entries(:one_sea_lab_sunday).full!
    arrange

    results = act

    assert_equal results, [{
      :kind=> "Service",
      :quantity=> 2.2,
      :unit_price=> @project.weekly_rate,
      :description=> "Sterling Mallory Archer\n\n(11.0/10.0 days worked)\nWorked on weekend 5/31\n"
    }]
  end
end
