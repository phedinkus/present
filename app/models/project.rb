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

  def self.invoiceable
    where('client_id is not null and special_type is null')
  end

  alias_method :original_client, :client
  def client
    return NullClient.new if special?
    self.original_client
  end

  def self.sticky
    where('special_type is not null')
  end

  def sticky?
    special_type?
  end

  def special?
    special_type?
  end

  def billable?
    !non_billable?
  end

  def non_billable?
    ["vacation", "holiday"].include?(special_type)
  end

  def unit_price
    if weekly?
      weekly_rate
    else
      hourly_rate
    end
  end
end
