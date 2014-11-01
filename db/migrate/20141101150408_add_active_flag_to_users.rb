class AddActiveFlagToUsers < ActiveRecord::Migration
  def change
    change_table :users do |t|
      t.boolean :active, :default => true, :null => false
    end
  end
end
