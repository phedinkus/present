class User < ActiveRecord::Base
  has_one :github_account
  has_many :timesheets

  def self.user_for(session_token)
    find_by(:session_token => session_token)
  end

  def self.login_via_github!(github_access_token_response, github_user_response, session_token)
    if github_account = GithubAccount.find_by(:github_id => github_user_response["id"])
      github_account.user.login_returning_github_user(github_access_token_response, session_token)
    else
      login_new_github_user!(github_access_token_response, github_user_response, session_token)
    end
  end

  def self.login_new_github_user!(github_access_token_response, github_user_response, session_token)
    create!(
      :name => github_user_response["name"],
      :session_token => session_token
    ).tap do |user|
      GithubAccount.create_from!(user, github_access_token_response, github_user_response)
    end
  end

  def login_returning_github_user(github_access_token_response, session_token)
    github_account.update_authorization(github_access_token_response)
    update(:session_token => session_token)
  end

  def admin?
    Rails.application.config.present.admins.include?(github_account.login)
  end
end
