module WeeksHelper
  def grouped_options_for_clients_and_projects_for(timesheet)
    clients_with_and_including_addable_projects = Client.
      includes(:projects).
      where(:active => true).
      where.not("projects.id" => timesheet.projects).
      where("projects.active" => true).
      order('clients.name, projects.name')

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
    timesheet.projects_timesheets
      .sort_by {|pt| [pt.project.sticky.to_s, pt.created_at]  }
      .map(&:project)
      .reject {|p| !@current_user.full_time? && (p.vacation? || p.holiday?) }
  end

  def ready_to_invoice_confirm_text(timesheet)
    <<-TEXT
Billable summary:

  Last week: #{timesheet.previous_timesheet.billable_time_human}
  This week: #{timesheet.billable_time_human }

Once marked ready, this week & last week will be locked
    TEXT
  end
end
