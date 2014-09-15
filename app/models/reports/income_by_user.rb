module Reports
  module IncomeByUser
    UserIncome = Struct.new(:name, :amount)

    def self.as_rows(start_date, end_date)
      Entry.between_inclusive(start_date, end_date).
        group_by(&:user).map do |(user, entries)|
          UserIncome.new(
            user.name,
            entries.map(&:price).sum
          )
      end
    end

    def self.as_csv(start_date, end_date)
      CSV.generate do |csv|
        csv << ["Name", "Amount (USD)"]
        as_rows(start_date, end_date).each do |a|
          csv << [a.name, a.amount]
        end
      end
    end
  end
end
