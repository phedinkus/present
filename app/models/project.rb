class Project < ActiveRecord::Base
  def self.active
    where(:active => true)
  end
end
