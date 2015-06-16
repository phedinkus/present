class RemoveRateDefaultsFromProjects < ActiveRecord::Migration
  def change
    change_column_default :projects, :weekly_rate, nil
    change_column_default :projects, :hourly_rate, nil
  end
end
