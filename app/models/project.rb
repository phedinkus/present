class Project < ActiveRecord::Base
  has_many :projects_timesheets
  has_many :entries, :through => :projects_timesheets
  belongs_to :client

  enum :rate_type => {
    :weekly => 0,
    :hourly => 1
  }

  def self.active
    where(:active => true)
  end

  def self.invoiceable
    where('client_id is not null and billable = ?', true)
  end

  alias_method :original_client, :client
  def client
    return NullClient.new if non_billable?
    self.original_client
  end

  def self.sticky
    where('sticky = ?', true)
  end

  def non_billable?
    !billable?
  end

  def vacation?
    non_billable? && name == "Vacation"
  end

  def holiday?
    non_billable? && name == "Holiday"
  end

  def unit_price
    if weekly?
      weekly_rate
    else
      hourly_rate
    end
  end
end
