class User < ActiveRecord::Base
  has_one :github_account
  has_many :timesheets
  has_many :entries, :through => :timesheets
  belongs_to :location

  accepts_nested_attributes_for :github_account

  validates_presence_of :location, :hire_date
  validates_numericality_of :days_between_pair_reminders, :greater_than_or_equal_to => 1, :allow_nil => true

  after_initialize :set_default_values
  before_validation :set_default_location, :unless => lambda { |u| u.location.present? }

  def self.login_via_github!(github_access_token_response, github_user_response, session_token)
    GithubAccount.find_or_initialize_by(:github_id => github_user_response["id"]).tap { |ga|
      ga.assign_attributes(
        :email => github_user_response["email"].present? ? github_user_response["email"] : ga.email,
        :login => github_user_response["login"],
        :access_token => github_access_token_response["access_token"],
        :scopes => github_access_token_response["scope"].split(","),
        :user => (ga.user || User.new).tap {|u|
          u.assign_attributes(
            :name => github_user_response["name"],
            :session_token => session_token
          )
        }
      )
    }.tap { |ga| ga.save! }.user
  end

  def self.active
    where(:active => true)
  end

  def self.alpha_sort
    order('full_time desc', :name)
  end

  def admin?
    Rails.application.config.present.admins.include?(github_account.login)
  end

  # TODO: Extracting the vacation & proration stuff would be a good refactor.
  def remaining_vacation_days_for(year)
    vacation_day_allotment_for(year.to_d) - vacation_days_used_for(year.to_d)
  end

private
  def set_default_values
    self.hire_date ||= Date.today
  end

  def vacation_day_allotment_for(year)
    vacation_days_per_year = ENV['PRESENT_PTO_DAYS_PER_YEAR'].to_d
    if hire_date.year == year
      days_in_year = Date.civil(year.to_i).end_of_year.yday
      day_of_year_hired = hire_date.strftime('%j').to_d
      ((vacation_days_per_year / days_in_year) * (days_in_year - day_of_year_hired)).round(0,BigDecimal::ROUND_UP)
    elsif year < hire_date.year
      0
    else
      vacation_days_per_year
    end
  end

  def vacation_days_used_for(year)
    entries.joins(:projects_timesheet, :timesheet).
      where('timesheets.year' => year).
      to_a.select {|e| e.project.vacation? && e.weekday? }.
      map(&:presence_day_value).
      sum
  end

  def set_default_location
    self.location = SystemConfiguration.instance.default_location
  end

end
