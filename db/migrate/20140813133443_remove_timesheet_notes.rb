class RemoveTimesheetNotes < ActiveRecord::Migration
  def change
    remove_column :timesheets, :notes, :text
  end
end
