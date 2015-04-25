class ProjectsController < ApplicationController
  before_filter :require_admin

  def index
    @projects = Project.all
  end

  def edit
    @project = Project.find(params[:id])
  end

  def update
    (project = Project.find(params[:id])).update!(params[:project].permit(:rate_type, :hourly_rate, :weekly_rate, :active, :requires_notes, :sticky, :billable))
    flash[:info] = ["Information updated for #{project.name}!"]
    redirect_to edit_project_path(project)
  end
end
