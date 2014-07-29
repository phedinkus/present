class CreateClients < ActiveRecord::Migration
  def change
    create_table :clients do |t|
      t.string :name
      t.integer :harvest_id
      t.boolean :active

      t.timestamps
    end

    change_table :projects do |t|
      t.references :client, :index => true
      t.integer :harvest_id
    end
  end
end
