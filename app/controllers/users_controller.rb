class UsersController < ApplicationController
  def index
    @grouped_users = User.alpha_sort.to_a.group_by do |user|
      if user.active?
        user.full_time? ? :double_agents : :special_agents
      else
        :sleeper_agents
      end
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    params[:user][:github_account_attributes] = params[:user][:github_account]
    user = User.find(params[:id])
    user.update!(permitted_edit_params(user, @current_user))
    flash[:info] = ["Information updated for #{user.name}!"]
    redirect_to users_path
  end

private

  def permitted_edit_params(user, editor)
    if @current_user.admin?
      params[:user].permit(:phone_number, :email, :twitter_handle, :tagline, :location_id, :full_time, :active, :hire_date, github_account_attributes: [:id, :email])
    elsif user == editor
      params[:user].permit(:phone_number, :email, :twitter_handle, :tagline)
    else
      raise "No editing other people's profiles!"
    end
  end
end
