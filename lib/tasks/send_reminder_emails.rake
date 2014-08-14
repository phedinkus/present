task :send_reminder_emails => :environment do |t, args|
  week = Week.now

  if Date.today.friday? && week.invoice_week?
    puts "Sending reminder e-mails for week ending #{week.end.to_s(:mdy)}"
    User.all.
      reject {|u| Timesheet.find_or_create_for!(week, u).ready_to_invoice? }.
      each do |u|
        TimesheetReminderMailer.reminder_email(u).deliver
        puts "Reminder sent to #{u.name} (at #{u.github_account.email})"
      end
  else
    puts "Skipped sending reminders:"
    puts "  * this week is not an invoicing week." if !week.invoice_week?
    puts "  * today is not Friday, so reminders were not sent." if !Date.today.friday?
  end
end
