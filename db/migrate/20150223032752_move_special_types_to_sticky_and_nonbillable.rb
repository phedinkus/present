class MoveSpecialTypesToStickyAndNonbillable < ActiveRecord::Migration
  class Project < ActiveRecord::Base
  end
  def change
    Project.where(:name => ["Holiday", "Vacation"]).update_all(
      :sticky => true,
      :billable => false
    )
  end
end
