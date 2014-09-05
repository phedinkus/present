class CreateLocations < ActiveRecord::Migration
  def change
    create_table :locations do |t|
      t.string :city
      t.string :state
      t.timestamps
    end

    change_table :users do |t|
      t.references :location
    end

    change_table :entries do |t|
      t.references :location
    end
  end
end
