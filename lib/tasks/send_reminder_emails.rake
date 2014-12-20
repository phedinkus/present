desc 'Send reminder e-mails to users'
task :send_reminder_emails => :environment do
  Jobs::TimesheetReminderEmails.send
  Jobs::PairingReminderEmails.send
end
