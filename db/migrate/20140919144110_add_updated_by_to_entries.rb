class AddUpdatedByToEntries < ActiveRecord::Migration
  def change
    add_reference :entries, :updated_by, index: true
  end
end
