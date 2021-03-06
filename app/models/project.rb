class Project < ActiveRecord::Base
  has_many :projects_timesheets
  has_many :entries, :through => :projects_timesheets
  belongs_to :client

  validates_presence_of :name, :weekly_rate, :hourly_rate

  after_initialize :assign_defaults

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
    self.original_client || NullClient.new
  end

  def self.sticky
    where('sticky = ?', true)
  end

  def non_billable?
    !billable?
  end

  def vacation?
    non_billable? && ["vacation", "paid time off"].include?(name.downcase)
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

private

  def assign_defaults
    self.weekly_rate ||= Rails.application.secrets.weekly_rate
    self.hourly_rate ||= Rails.application.secrets.hourly_rate
  end
end
