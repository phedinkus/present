module Jobs
  module PairingReminderEmails
    def self.send(now = Time.zone.now)
      Job.create!(:name => "send_pairing_reminder_emails").tap do |job|
        puts "Starting job #{job.id}; sending pairing reminder e-mails for #{now.to_s(:mdy)}"

        User.active
          .where.not(:days_between_pair_reminders => nil)
          .select { |u| u.github_account.email.present? }
          .select { |u| needs_reminder?(u) }
          .each do |user|
            PairingReminderMailer.reminder_email(user).deliver
        end
      end.update!(:finished_at => Time.zone.now)
    end

    private

    def self.needs_reminder?(user)
      AccidentalPairing.days_since_last_pairing_for(user) % user.days_between_pair_reminders == 0
    end

  end
end
