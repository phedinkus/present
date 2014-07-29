class Project < ActiveRecord::Base
  belongs_to :client

  enum :rate_type => {
    :weekly => 0,
    :hourly => 1
  }

  def self.active
    where(:active => true)
  end

  def unit_price
    if weekly?
      weekly_rate
    else
      hourly_rate
    end
  end
end
