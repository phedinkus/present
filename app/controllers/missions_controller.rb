class MissionsController < ApplicationController
  def create
    upsert
  end

  def update
    upsert
  end

private

  def upsert
    Mission.find_or_initialize_by(params[:mission].permit(:id, :user_id, :year, :month))
      .update!(params[:mission].permit(:project_id, :project_placeholder_description))
    redirect_to dossiers_path
  end
end
