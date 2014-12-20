class User < ActiveRecord::Base
  has_one :github_account
  has_many :timesheets
  has_many :entries, :through => :timesheets
  belongs_to :location

  validates_presence_of :location
  validates_numericality_of :days_between_pair_reminders, :greater_than_or_equal_to => 1, :allow_nil => true


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

  def admin?
    Rails.application.config.present.admins.include?(github_account.login)
  end

private

  def set_default_location
    self.location = SystemConfiguration.instance.default_location
  end

end
