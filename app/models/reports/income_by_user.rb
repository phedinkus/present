module Reports
  module IncomeByUser
    UserIncome = Struct.new(:name, :amount, :projects_billed, :days_worked, :first_billable_entry_at, :last_billable_entry_at, :holidays_taken, :vacation_days_used, :weekdays_not_billed_or_taken_off)

    def self.as_rows(start_date, end_date)
      Entry.between_inclusive(start_date, end_date).
        group_by(&:user).map do |(user, entries)|
          UserIncome.new(
            user.name,
            (billable_entries = entries.select { |e| e.nonzero? && e.project.billable? }).map(&:price).sum,
            billable_entries.map(&:project).uniq.size,
            billable_entries.map(&:date).uniq.size,
            billable_entries.map(&:time).min,
            billable_entries.map(&:time).max,
            (holiday_entries = entries.select {|e| e.project.holiday? && e.weekday? }).map(&:presence_day_value).sum,
            (vacation_entries = entries.select {|e| e.project.vacation? && e.weekday? }).map(&:presence_day_value).sum,
            ((start_date..end_date).to_a.reject {|d| d.saturday? || d.sunday? } - (billable_entries + holiday_entries + vacation_entries).map(&:date)).size
          )
      end
    end

    def self.as_csv(start_date, end_date)
      CSV.generate do |csv|
        csv << UserIncome.members.map(&:to_s).map(&:titleize)
        as_rows(start_date, end_date).each do |a|
          csv << [a.name, a.amount,  a.projects_billed, a.days_worked, a.first_billable_entry_at.try(:to_s, :ymd_dash), a.last_billable_entry_at.try(:to_s, :ymd_dash), a.holidays_taken, a.vacation_days_used, a.weekdays_not_billed_or_taken_off]
        end
      end
    end
  end
end
