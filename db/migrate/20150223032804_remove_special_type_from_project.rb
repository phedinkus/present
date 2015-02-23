class RemoveSpecialTypeFromProject < ActiveRecord::Migration
  def change
    remove_column :projects, :special_type, :string
  end
end
