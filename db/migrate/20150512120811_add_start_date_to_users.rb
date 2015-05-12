class AddStartDateToUsers < ActiveRecord::Migration
  def change
    change_table :users do |t|
      t.date :hire_date, :null => false, :default => Date.civil(2014,12,31)
    end
  end
end
