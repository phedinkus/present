class CreateTimesheets < ActiveRecord::Migration
  def change
    create_table :timesheets do |t|
      t.references :user, :index => true
      t.integer :year
      t.integer :month
      t.integer :day
      t.text :notes

      t.timestamps
    end

    create_table :projects do |t|
      t.string :name
      t.boolean :active, :default => true
    end

    create_table :entries do |t|
      t.references :projects_timesheet, :index => true
      t.integer :day
      t.integer :presence, :default => 0
      t.integer :hours

      t.timestamps
    end
  end
end
