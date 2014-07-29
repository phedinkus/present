class AddPricesToProjects < ActiveRecord::Migration
  def change
    change_table :projects do |t|
      t.integer :weekly_rate, :default => ENV['PRESENT_WEEKLY_RATE'].to_i
      t.integer :hourly_rate, :default => ENV['PRESENT_HOURLY_RATE'].to_i
    end
  end
end
