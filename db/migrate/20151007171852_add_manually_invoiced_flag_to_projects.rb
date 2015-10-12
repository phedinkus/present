class AddManuallyInvoicedFlagToProjects < ActiveRecord::Migration
  def change
    change_table :projects do |t|
      t.boolean :manually_invoiced, :default => false
    end
  end
end
