class AddStatusToMission < ActiveRecord::Migration
  def change
    change_table :missions do |t|
      t.integer :status
    end
  end
end
