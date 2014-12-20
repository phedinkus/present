class CreateAccidentalPairings < ActiveRecord::Migration
  def change
    create_table :accidental_pairings do |t|
      t.belongs_to :user
      t.text :description
      t.datetime :paired_at
      t.timestamps
    end
  end
end
