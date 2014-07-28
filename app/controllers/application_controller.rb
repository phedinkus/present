class ApplicationController < ActionController::Base
  protect_from_forgery :with => :exception

  before_action :require_login

  def root
    redirect_to current_week_path
  end

  def require_login
    unless @current_user = User.user_for(session[:session_token])
      session[:github_oauth_attempted_url] = request.url
      redirect_to Github::OAuth.login_url_for_state(session[:github_oauth_state] = SecureRandom.base64(100))
    end
  end
end
