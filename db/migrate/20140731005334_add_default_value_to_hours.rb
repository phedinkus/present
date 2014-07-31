class AddDefaultValueToHours < ActiveRecord::Migration
  def change
    change_column :entries, :hours, :decimal, :default => 0
  end
end
