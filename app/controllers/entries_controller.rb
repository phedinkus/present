class EntriesController < ApplicationController
  def set_locations
    if params[:model] == "entry"
      @current_user.entries.find(params[:model_id]).update!(
        :location => Location.find(params[:location_id])
      )
    elsif params[:model] == "timesheet"
      @current_user.timesheets.find(params[:model_id]).entries.update_all(
        :location_id => Location.find(params[:location_id])
      )
    end
    head :no_content
  end
end
