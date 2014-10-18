class ApplicationController < ActionController::Base
  protect_from_forgery :with => :exception

  before_action :require_login, :apply_impersonation

  def root
    redirect_to current_week_path
  end

  def require_login
    return @logged_in_user = @current_user = User.find_by(:name => Rails.application.config.present.local_override) if Rails.application.config.present.local_override.present?

    unless @logged_in_user = @current_user = User.user_for(session[:session_token])
      session[:github_oauth_attempted_url] = request.url
      redirect_to Github::OAuth.login_url_for_state(session[:github_oauth_state] = SecureRandom.base64(100))
    end
  end

  def apply_impersonation
    return unless @logged_in_user.present?

    if session[:impersonated_user_id].present? && @logged_in_user.admin?
      @impersonated_user = @current_user = User.find(session[:impersonated_user_id])
    end
  end

  def require_admin
    unless @logged_in_user.admin?
      render :text => "Sorry, this feature is only available to admins!"
    end
  end
end
