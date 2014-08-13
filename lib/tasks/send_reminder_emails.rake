task :send_reminder_emails, [:week] => :environment do |t, args|
  week = case args[:week]
    when "last" then Week.now.previous
    when "next" then Week.now.next
    else Week.now
  end

  puts "Sending reminder e-mails for week ending #{week.end.to_s(:mdy)}"
  raise "Week #{week.ymd_dash} not an invoicing week! Did you mean last week? Try 'rake send_reminder_emails[last]'" unless week.invoice_week?

  User.all.
    reject {|u| Timesheet.find_or_create_for!(week, u).ready_to_invoice? }.
    each do |u|
      TimesheetReminderMailer.reminder_email(u).deliver
      puts "Reminder sent to #{u.name} (at #{u.github_account.email})"
    end
end
