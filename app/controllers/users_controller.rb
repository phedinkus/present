class UsersController < ApplicationController
  before_filter :require_admin

  def index
    @users = User.all
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    (@user = User.find(params[:id])).update!(params[:user].permit(:location_id))
    flash[:info] = ["Information updated for #{@user.name}!"]
    redirect_to edit_user_path(@user)
  end
end
