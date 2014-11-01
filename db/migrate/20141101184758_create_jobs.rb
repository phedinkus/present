class CreateJobs < ActiveRecord::Migration
  def change
    create_table :jobs do |t|
      t.string :name
      t.time :finished_at
      t.timestamps
    end
  end
end
