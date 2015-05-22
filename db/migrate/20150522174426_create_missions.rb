class CreateMissions < ActiveRecord::Migration
  def change
    create_table :missions do |t|
      t.belongs_to :user
      t.belongs_to :project
      t.string :project_placeholder_description
      t.integer :year
      t.integer :month
    end
  end
end
