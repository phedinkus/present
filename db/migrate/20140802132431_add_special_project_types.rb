class AddSpecialProjectTypes < ActiveRecord::Migration
  def change
    change_table :projects do |t|
      t.string :special_type
    end

  end
end
