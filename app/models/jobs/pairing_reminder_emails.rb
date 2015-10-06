module Jobs
  module PairingReminderEmails
    def self.send(now = Time.zone.now)
      return if weekend?(now)

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
      return unless (days_since_pairing = days_since_pairing?(user)) > 0
      days_since_pairing % user.days_between_pair_reminders == 0
    end

    def self.days_since_pairing?(user)
      AccidentalPairing.days_since_last_pairing_for(user)
    end

    def self.weekend?(now)
      now = now.in_time_zone("Eastern Time (US & Canada)")
      now.saturday? || now.sunday?
    end
  end
end
