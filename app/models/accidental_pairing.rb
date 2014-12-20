class AccidentalPairing < ActiveRecord::Base
  belongs_to :user

  def self.for_user(user)
    where(:user => user)
  end

  def self.days_since_last_pairing_for(user)
    if last_paired_at = since_last_pairing_for(user)
      (last_paired_at / 1.day.seconds).to_i
    end
  end

  def self.since_last_pairing_for(user)
    if pairing = for_user(user).order('paired_at desc').first
      Time.zone.now - pairing.paired_at
    else
      nil
    end
  end
end
