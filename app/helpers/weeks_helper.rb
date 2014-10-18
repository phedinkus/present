module WeeksHelper
  def grouped_options_for_clients_and_projects_for(timesheet)
    clients_with_and_including_addable_projects = Client
      .includes(:projects)
      .where(:active => true)
      .where.not("projects.id" => timesheet.projects)
      .where("projects.active" => true)

    Hash[
      clients_with_and_including_addable_projects.map do |c|
        [c.name, c.projects.map {|p| [p.name, p.id] } ]
      end
    ]
  end

  def locked?
    @timesheet.locked? && !@logged_in_user.admin?
  end

  def sort_projects(timesheet)
    timesheet.projects_timesheets.sort_by {|pt| [pt.project.special_type.to_s, pt.created_at]  }.map(&:project)
  end
end
