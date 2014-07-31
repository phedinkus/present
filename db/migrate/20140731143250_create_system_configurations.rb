class CreateSystemConfigurations < ActiveRecord::Migration
  def change
    create_table :system_configurations do |t|
      t.integer :reference_invoice_year
      t.integer :reference_invoice_month
      t.integer :reference_invoice_day
    end
  end
end
