class AddInvoiceReadyToTimesheets < ActiveRecord::Migration
  def change
    change_table :timesheets do |t|
      t.boolean :ready_to_invoice, :default => false
    end
  end
end
