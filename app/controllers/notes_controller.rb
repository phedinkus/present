class NotesController < ApplicationController

  def internal
    make_ivar_mess(Project.find_by(:name => "Internal", :requires_notes => true))
    render :index
  end

  def index
    make_ivar_mess(Project.find(params[:project_id]))
  end

private

  def make_ivar_mess(project)
    @project = project
    @week = params[:week].present? ? Week.new(Time.zone.parse(params[:week])) : Week.now
    @user_notes = user_notes_for(@project, @week)
  end

  def user_notes_for(project, week)
    Hash[ProjectsTimesheet.joins(:project, :timesheet).
      merge(Timesheet.for_week(@week)).
      where('projects.id' => @project).
      where("notes is not null and notes <> ''").
      map { |pt| [pt.timesheet.user, pt.notes] }]
  end
end
