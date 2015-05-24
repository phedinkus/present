class MissionsController < ApplicationController
  def create
    upsert
  end

  def update
    upsert
  end

private

  def upsert
    mission = UpsertsMissions.new.upsert(params[:mission].permit(:id, :user_id, :year, :month, :project_id, :project_placeholder_description))
    render :json => mission
  end

  class UpsertsMissions
    def upsert(params)
      Mission.find_or_initialize_by(
        :id => params[:id],
        :user_id => params[:user_id],
        :year => params[:year],
        :month => params[:month]
      ).tap { |p| p.update!(sane_project_params_for(params)) }
    end

  private

    def sane_project_params_for(params)
      {
        :project_id => params[:project_id],
        :project_placeholder_description => params[:project_placeholder_description]
      }.tap {|h| h[:project_placeholder_description] = nil if h[:project_placeholder_description] == ""}.
        tap {|h| h[:status] = status_for(h) }
    end

    def status_for(project_params)
      if project_params[:project_id].present?
        'deployed'
      elsif project_params[:project_placeholder_description].present?
        'tentative'
      else
        'available'
      end
    end

  end
end
