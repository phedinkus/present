module Answers
  module TimesheetStatus
    Answer = Struct.new(:invoice_week, :user_count, :expected_count, :actual_count, :missing_timesheets, :not_ready_timesheets, :looks_good)
    MissingTimesheet = Struct.new(:user, :week)
    def self.status_for(week = Week.now)
      week = week.closest_invoice_week
      weeks = [week.previous, week]
      Hash[User.where(:active => true).map do |user|
        [user, weeks.map { |w| Timesheet.find_by(w.ymd_hash.merge(:user => user)) }]
      end].reduce(Answer.new(week, 0, 0, 0, [], [], true)) do |answer, (user, timesheets)|
        answer.tap do |answer|
          answer.user_count += 1
          answer.expected_count += weeks.count
          answer.actual_count += timesheets.compact.count
          answer.missing_timesheets += timesheets.each_with_index.map {|t, i| MissingTimesheet.new(user, weeks[i]) if t.nil? }.compact
          answer.not_ready_timesheets += timesheets.compact.reject(&:ready_to_invoice)
          answer.looks_good = false unless answer.missing_timesheets.empty? && answer.not_ready_timesheets.empty?
        end
      end
    end
  end
end
