module NotesHelper
  def path_for_project_notes(week = Week.now)
    project_notes_for_week_path(week.ymd_hash.merge(:project_id => @project.id))
  end
end
