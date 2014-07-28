class WeeksController < ApplicationController
  def current
    render :json => {
      :session_token => session[:session_token],
      :user => @current_user
    }
  end
end
