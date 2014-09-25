class InvoiceTodos
  InvoiceTodo = Struct.new(:client_name, :project, :agent_count, :all_time_sent_to_harvest, :invoice)
  attr_reader :weeks, :todos

  def initialize(weeks, todos)
    @weeks = weeks
    @todos = todos
  end

  def self.gather(time)
    weeks = [Week.new(time).previous_invoice_week.previous, Week.new(time).previous_invoice_week]

    new(weeks,
      ProjectsTimesheet.
        joins(:timesheet).
        merge(Timesheet.between_inclusive(weeks.first.beginning, weeks.last.end)).
        joins(:project).merge(Project.invoiceable).
        group_by(&:project).map do |(p, pts)|
          InvoiceTodo.new(p.client.name, p, pts.map(&:timesheet).map(&:user).uniq.count, pts.all?(&:sent_to_harvest_at?), pts.map(&:invoice).compact.sample)
        end
    )
  end
end
