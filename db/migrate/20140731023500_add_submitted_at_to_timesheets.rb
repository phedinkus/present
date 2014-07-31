class AddSubmittedAtToTimesheets < ActiveRecord::Migration
  def change
    change_table :projects_timesheets do |t|
      t.timestamp :sent_to_harvest_at
    end
  end
end
