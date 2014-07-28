class AuthorizationsController < ApplicationController
  skip_before_filter :require_login

  def github
    return render :text => "Github login looks like an XSS attack. Make sure cookies are enabled and that nobody is MITM'ing you." if github_xss_violation?

    auth = Github::OAuth.request_access_token_for_code(params[:code])
    user = Github::Api.user_for_access_token(auth["access_token"])
    session[:session_token] = SecureRandom.base64(100)
    @current_user = User.login_via_github!(auth, user, session[:session_token])

    redirect_to session[:github_oauth_attempted_url]
  end

private

  def github_xss_violation?
    params[:state] != session[:github_oauth_state]
  end
end
