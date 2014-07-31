module Present::Harvest
  module LineItems

    def self.generate(invoice, entries, timesheets)
      project = invoice.project

      entries.group_by {|e| e.timesheet.user }.map do |(user, entries)|
        entries.reduce({
          :kind => "Service",
          :quantity => 0.0,
          :unit_price => project.unit_price
        }) do |memo, entry|
          memo.merge(:quantity => memo[:quantity] + quantity_for(project, entry))
        end.tap do |line_item|
          line_item[:description] = description_for(project, user, line_item, entries)
          line_item[:quantity] = line_item[:quantity].round(2)
        end
      end
    end

  private

    def self.quantity_for(project, entry)
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

    def self.description_for(project, user, line_item, entries)
      if project.hourly?
        <<-TEXT.gsub /^\s+/, ""
          #{user.name}
          #{description_of_present_entries_date_range(entries)}
        TEXT
      else
        <<-TEXT.gsub /^\s+/, ""
          #{user.name} (#{line_item[:quantity] * 5.0}/10 days worked)
          #{description_of_present_entries_date_range(entries)}
          #{description_of_absences_for(entries).join("\n")}
        TEXT
      end
    end

    def self.description_of_present_entries_date_range(entries)
      return "" if (entry_times = entries.select(&:nonzero?).map(&:time)).blank?
      "#{entry_times.min.to_s(:mdy)} - #{entry_times.max.to_s(:mdy)}"
    end

    def self.description_of_absences_for(entries)
      entries.reject(&:full?).map do |entry|
        "#{entry.absent? ? 'Absent' : 'Half-day'} on #{entry.time.to_s(:md)}"
      end
    end

  end
end
