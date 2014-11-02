module Jobs
  module ReminderEmails
    def self.send(now = Time.zone.now)
      return unless now.sunday?
      week = Week.new(now)
      return if week.invoice_week?

      puts "YAY! I MADE IT #{Time.zone.now}"

      # Job.create!(:name => "send_reminder_emails").tap do |job|
      #   puts "Starting job #{job.id}; sending reminder e-mails for invoice week starting #{week.ymd_dash}"
      #   timesheet_status = Answers::TimesheetStatus.status_for(week)
      #
      #   (timesheet_status.missing_timesheets.map(&:user) + timesheet_status.not_ready_timesheets.map(&:user)).compact.uniq.each do |(user, timesheets)|
      #     mail = if user.github_account.email.present?
      #       TimesheetReminderMailer.reminder_email(user).tap do |mail|
      #         mail.deliver
      #         puts "Reminder sent to #{user.name} (at #{user.github_account.email})"
      #       end
      #     else
      #       TimesheetReminderMailer.reminder_failed_email(user).tap do |mail|
      #         mail.deliver
      #         puts "Reminder could not be sent to #{user.name}, notified admins instead."
      #       end
      #     end
      #
      #     Email.create!(:job => job, :mailer => "TimesheetReminderMailer", :to => mail.to.join(", "), :subject => mail.subject, :body => mail.body.to_s)
      #   end
      # end.update!(:finished_at => Time.zone.now)
    end
  end
end
