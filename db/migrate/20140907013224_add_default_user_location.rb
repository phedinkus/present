class AddDefaultUserLocation < ActiveRecord::Migration
  def change
    change_table :system_configurations do |t|
      t.integer :default_location_id
    end
  end
end
