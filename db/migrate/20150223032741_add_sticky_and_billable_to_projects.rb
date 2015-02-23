class AddStickyAndBillableToProjects < ActiveRecord::Migration
  def change
    change_table :projects do |t|
      t.boolean :sticky, :default => false
      t.boolean :billable, :default => true
    end
  end
end
