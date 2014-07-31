class AddSubmittedAtToTimesheets < ActiveRecord::Migration
  def change
    change_table :timesheets do |t|
      t.time :sent_to_harvest_at
    end
  end
end
