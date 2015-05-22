class AddUniqueConstraintToMissionsByUserAndMonth < ActiveRecord::Migration
  def change
    add_index :missions, [:user_id, :year, :month], :unique => true
  end
end
