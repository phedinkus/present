class AddUserPairingReminderSettings < ActiveRecord::Migration
  def change
    change_table :users do |t|
      t.integer :days_between_pair_reminders
    end
  end
end
