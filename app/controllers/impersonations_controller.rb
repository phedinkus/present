class ImpersonationsController < ApplicationController
  before_filter :require_admin

  def index
  end

  def create
    if params[:commit] == "Impersonate"
      session[:impersonated_user_id] = params[:impersonated_user_id]
    else
      session.delete(:impersonated_user_id)
    end
    redirect_to impersonations_path
  end

end
