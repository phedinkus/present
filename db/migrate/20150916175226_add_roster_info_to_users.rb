class AddRosterInfoToUsers < ActiveRecord::Migration
  def change
    change_table :users do |t|
      t.string :phone_number
      t.string :email
      t.string :twitter_handle
      t.string :tagline
    end
  end
end
