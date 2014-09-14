class WeeksController < ApplicationController
  def current
    @week = Week.now
    @timesheet = Timesheet.find_or_create_for!(@week, @current_user)
    render :show
  end

  def show
    @week = Week.for(params[:year], params[:month], params[:day])
    @timesheet = Timesheet.find_or_create_for!(@week, @current_user)
  end

  def update
    @current_user.timesheets.find(params[:timesheet][:id]).tap do |timesheet|
      message = "Saved successfully!"
      if params[:button] == "add_project"
        timesheet.projects << project = Project.find(params[:timesheet][:projects]) unless timesheet.locked?
        message = "Project '#{project.name}' added!"
      elsif params[:commit] == "Ready to Invoice"
        timesheet.update(:ready_to_invoice => true)
        message = "Ready for invoice!"
      else
        timesheet.update(params[:timesheet].permit(
          :entries_attributes => [:id, :presence, :hours],
          :projects_attributes => [:id, :_destroy],
          :projects_timesheets_attributes => [:id, :notes]
        ))
      end

      unless (flash[:error] = timesheet.errors.full_messages).present?
        flash[:info] = [message]
      end

      redirect_to show_week_path(:year => timesheet.year, :month => timesheet.month, :day => timesheet.day)
    end
  end
end
