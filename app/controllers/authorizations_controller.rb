class AuthorizationsController < ApplicationController
  skip_before_filter :require_login

  def github
    return render :text => "Github login looks like an XSS attack. Make sure cookies are enabled and that nobody is MITM'ing you." if github_xss_violation?

    auth = request_github_access_token
    user = fetch_github_user(auth["access_token"])

    @current_user = if github_account = GithubAccount.find_by(:github_id => user["id"])
      github_account.update(
        :access_token => auth["access_token"],
        :scopes => auth["scope"].split(",")
      )
      github_account.user.tap do |user|
        user.update(
          :session_token => session[:session_token] = SecureRandom.base64(100)
        )
      end
    else
      User.create!(
        :name => user["name"],
        :session_token => session[:session_token] = SecureRandom.base64(100)
      ).tap do |app_user|
        GithubAccount.create!(
          :user => app_user,
          :github_id => user["id"],
          :login => user["login"],
          :access_token => auth["access_token"],
          :scopes => auth["scope"].split(",")
        )
      end
    end

    redirect_to session[:github_oauth_attempted_url]
  end


private

  def github_xss_violation?
    params[:state] != session[:github_oauth_state]
  end

  def request_github_access_token
    JSON.parse(Faraday.new(:url => 'https://github.com/login/oauth/access_token').post do |req|
      req.params = {
        :client_id => Rails.application.config.github.client_id,
        :client_secret => Rails.application.secrets.github_client_secret,
        :code => params[:code]
      }
      req.headers["Accept"] = "application/json"
    end.body)
  end

  def fetch_github_user(access_token)
    JSON.parse(Faraday.new(:url => 'https://api.github.com').get('/user', :access_token => access_token).body)
  end
end
