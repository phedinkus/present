class ProjectsController < ApplicationController
  before_filter :require_admin

  def index
    @projects = Project.order('name')
  end

  def new
    @project = Project.new(:active => true)
    render :edit
  end

  def create
    @project = Project.new(project_params)
    Project.transaction do
      begin
        @project.save!
        Present::Harvest::CreateProject.new.create!(@project)
      rescue
        raise ActiveRecord::Rollback
      end
    end
    if @project.id?
      flash[:info] = ["Project #{@project.name} created!"]
      redirect_to projects_path
    else
      flash[:error] = ["Project creation failed!"] + @project.errors.full_messages
      render :edit
    end
  end

  def edit
    @project = Project.find(params[:id])
  end

  def update
    (project = Project.find(params[:id])).update!(project_params)
    flash[:info] = ["Information updated for #{project.name}!"]
    redirect_to edit_project_path(project)
  end

private

  def project_params
    params[:project].permit(:name, :client_id, :rate_type, :hourly_rate, :weekly_rate, :active, :requires_notes, :sticky, :billable)
  end
end
