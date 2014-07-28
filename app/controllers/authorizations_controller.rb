class AuthorizationsController < ApplicationController
  skip_before_filter :require_login

  after_filter :clear_temporary_oauth_session_variables

  def github
    return render :text => "Github login looks like an XSS attack. Make sure cookies are enabled and that nobody is MITM'ing you." if github_xss_violation?

    auth = Github::OAuth.request_access_token_for_code(params[:code])
    github = Github::Api.new(auth["access_token"])

    return render :text => "Sorry, Test Double Present™ is only open to Double Agents. E-mail join@testdouble.com to remedy this situation." unless github.test_double_agent?

    session[:session_token] = SecureRandom.base64(100)
    @current_user = User.login_via_github!(auth, github.user, session[:session_token])

    redirect_to session[:github_oauth_attempted_url]
  end

private

  def github_xss_violation?
    params[:state] != session[:github_oauth_state]
  end

  def clear_temporary_oauth_session_variables
    session.delete(:github_oauth_attempted_url)
    session.delete(:github_oauth_state)
  end
end
