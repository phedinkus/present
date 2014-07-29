class CreateInvoices < ActiveRecord::Migration
  def change
    create_table :invoices do |t|
      t.references :project
      t.integer :year
      t.integer :month
      t.integer :day

      t.integer :harvest_id

      t.timestamps
    end
  end
end
