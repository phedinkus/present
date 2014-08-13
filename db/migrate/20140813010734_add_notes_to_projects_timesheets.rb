class AddNotesToProjectsTimesheets < ActiveRecord::Migration
  def change
    change_table :projects_timesheets do |t|
      t.text :notes
    end

    change_table :projects do |t|
      t.boolean :requires_notes, :default => false
    end
  end
end
