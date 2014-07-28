class ApplicationController < ActionController::Base
  protect_from_forgery :with => :exception

  before_action :require_login

  def require_login
    unless @current_user = User.user_for(session[:session_token])
      session[:github_oauth_attempted_url] = request.url
      redirect_to "https://github.com/login/oauth/authorize?" + {
        :client_id => Rails.application.config.github.client_id,
        :state => session[:github_oauth_state] = SecureRandom.base64(100)
      }.to_param
    end
  end
end
