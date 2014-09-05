class User < ActiveRecord::Base
  has_one :github_account
  has_many :timesheets
  belongs_to :location

  def self.user_for(session_token)
    find_by(:session_token => session_token)
  end

  def self.login_via_github!(github_access_token_response, github_user_response, session_token)
    GithubAccount.find_or_initialize_by(:github_id => github_user_response["id"]).tap { |ga|
      ga.assign_attributes(
        :email => github_user_response["email"],
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

  def admin?
    Rails.application.config.present.admins.include?(github_account.login)
  end
end
