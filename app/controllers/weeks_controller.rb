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
      if params[:button] == "add_project"
        timesheet.projects << Project.find(params[:timesheet][:projects])
      else
        timesheet.update(params[:timesheet].permit(
          :notes,
          :entries_attributes => [:id, :presence, :hours],
          :projects_attributes => [:id, :_destroy]
        ))
      end

      flash[:error] = timesheet.errors.full_messages

      redirect_to show_week_path(:year => timesheet.year, :month => timesheet.month, :day => timesheet.day)
    end
  end
end
