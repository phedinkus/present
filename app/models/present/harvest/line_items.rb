module Present::Harvest
  module LineItems

    def self.generate(project, entries)
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
      return user.name if project.hourly?
      <<-TEXT.gsub /^\s+/, ""
        #{user.name} (#{line_item[:quantity] * 5.0}/10 days worked)

        #{description_of_absences_for(entries)}
        #{description_of_half_days_for(entries)}
      TEXT
    end

    def self.description_of_absences_for(entries)
      return unless (absences = description_of_entry_days(entries.select(&:absent?))).present?
      "Absent on #{absences}"
    end

    def self.description_of_half_days_for(entries)
      return unless (half_days = description_of_entry_days(entries.select(&:half?))).present?
      "Half-day on #{half_days}"
    end

    def self.description_of_entry_days(entries)
      entries
        .reject(&:saturday?)
        .reject(&:sunday?)
        .sort_by { |e| e.time }
        .map {|e| e.time.to_s(:md)}
      .join(", ")
    end

  end
end
