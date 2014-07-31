class Invoice < ActiveRecord::Base
  belongs_to :project

  def subject
    "Consulting services from #{prior_week.to_s(:mdy)} to #{invoicing_week.end.to_s(:mdy)}"
  end

  def line_items
    invoice_entries.group_by {|e| e.timesheet.user }.map do |(user, entries)|
      entries.reduce({
        :kind => "Service",
        :quantity => 0.0,
        :unit_price => project.unit_price
      }) do |memo, entry|
        memo.merge(:quantity => memo[:quantity] + quantity_for(entry))
      end.tap do |line_item|
        line_item[:description] = description_for(user, line_item)
        line_item[:quantity] = line_item[:quantity].round(2)
      end
    end
  end

  def user_timesheets
    invoice_entries.map(&:timesheet).uniq.group_by(&:user)
  end

private

  def invoicing_week
    Week.new(Time.zone.local(year, month, day))
  end

  def prior_week
    invoicing_week.previous
  end

  def quantity_for(entry)
    if project.weekly?
      case entry.presence
        when "full" then 1.0 / 5.0
        when "half" then 0.5 / 5.0
        else 0
      end
    else
      entry.hours
    end
  end

  def description_for(user, line_item)
    return user.name if project.hourly?
    "#{user.name} (#{line_item[:quantity] * 5.0}/10 days worked)"
  end

  def invoice_entries
    Entry.non_zero_entries_for_week_and_project(prior_week, project) +
    Entry.non_zero_entries_for_week_and_project(invoicing_week, project)
  end

end
