class Project < ActiveRecord::Base
  belongs_to :client

  def self.active
    where(:active => true)
  end
end
