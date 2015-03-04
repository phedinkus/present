module Present::Harvest
  module LineItems

    def self.generate(project, entries)
      entries.group_by {|e| e.timesheet.user }.map do |(user, entries)|
        {
          :kind => "Service",
          :quantity => quantity_for_entries(project, entries),
          :unit_price => project.unit_price,
          :description => description_for(project, user, entries)
        }
      end
    end

  private

    def self.quantity_for_entries(project, entries)
      entries.map {|entry| quantity_for(project, entry)}.reduce(:+).round(2)
    end

    def self.quantity_for(project, entry)
      if project.weekly?
        entry.amount / 5.0
      else
        entry.hours
      end
    end

    def self.description_for(project, user, entries)
      description = user.name
      if project.requires_notes?
        description += "\n\n#{description_of_notes_for(entries)}"
      end
      if project.weekly?
        description += "\n\n"
        description += <<-TEXT.gsub /^\s+/, ""
          (#{quantity_for_entries(project, entries) * 5}/10.0 days worked)

          #{description_of_absences_for(entries)}
          #{description_of_half_days_for(entries)}
        TEXT
      end
      description
    end

    def self.description_of_notes_for(entries)
      entries.sort_by(&:time).map(&:projects_timesheet).uniq.map(&:notes).join("\n\n").strip
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
