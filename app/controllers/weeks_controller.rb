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
        if @logged_in_user.admin? || !timesheet.locked?
          timesheet.projects << project = Project.find(params[:timesheet][:projects])
          message = "Project '#{project.name}' added!"
        end
      else
        timesheet.update(merge_entries_updated_by!(params[:timesheet].permit(
          :entries_attributes => [:id, :presence, :hours],
          :projects_attributes => [:id, :_destroy],
          :projects_timesheets_attributes => [:id, :notes]
        )))

        if params[:commit] == "Ready to Invoice"
          timesheet.update(:ready_to_invoice => true)
          message = "Saved & Marked Ready for invoice!"
        end
      end

      unless (flash[:error] = timesheet.errors.full_messages).present?
        flash[:info] = [message]
      end

      redirect_to show_week_path(:year => timesheet.year, :month => timesheet.month, :day => timesheet.day)
    end
  end

private

  def merge_entries_updated_by!(params)
    params.tap do |params|
      if params[:entries_attributes].present?
        params[:entries_attributes].each do |(ordinal, entry_attributes)|
          entry_attributes[:updated_by_id] = @logged_in_user.id
        end
      end
    end
  end
end
