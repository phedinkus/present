module Reports
  module IncomeByLocation
    LocationIncome = Struct.new(:city, :state, :amount)

    def self.as_rows(start_date, end_date)
      Entry.joins(:timesheet).
        merge(Timesheet.between_inclusive(start_date,end_date)).
        select { |e| e.date.between?(start_date, end_date) }.
        group_by(&:location).map do |(location, entries)|
          LocationIncome.new(
            location.city,
            location.state,
            entries.map(&:price).sum
          )
      end
    end

    def self.as_csv(start_date, end_date)
      CSV.generate do |csv|
        csv << ["City", "State/Province", "Amount (USD)"]
        as_rows(start_date, end_date).each do |a|
          csv << [a.city, a.state, a.amount]
        end
      end
    end
  end
end
