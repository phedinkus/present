class AddWeeklyOrHourlyToProjects < ActiveRecord::Migration
  def change
    change_table :projects do |t|
      t.integer :rate_type, :default => 0
    end
  end
end
