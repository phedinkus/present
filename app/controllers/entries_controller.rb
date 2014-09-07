class EntriesController < ApplicationController
  def set_locations
    @current_user.timesheets.find(params[:model_id]).entries.update_all(
      :location_id => Location.find(params[:location_id])
    )
    head :no_content
  end
end
