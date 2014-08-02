class Project < ActiveRecord::Base
  has_many :projects_timesheets
  belongs_to :client

  enum :rate_type => {
    :weekly => 0,
    :hourly => 1
  }

  def self.active
    where(:active => true)
  end

  after_initialize { |p| p.client = NullClient.new if p.special? }

  def sticky?
    special_type?
  end

  def special?
    special_type?
  end

  def unit_price
    if weekly?
      weekly_rate
    else
      hourly_rate
    end
  end
end
