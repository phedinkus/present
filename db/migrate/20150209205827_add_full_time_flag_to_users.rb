class AddFullTimeFlagToUsers < ActiveRecord::Migration
  def change
    change_table :users do |t|
      t.boolean :full_time, :default => true, :null => false
    end
  end
end
