module Present::Harvest
  class GeneratedInvoice
    extend Forwardable
    def_delegators :@invoice, :id, :harvest_id, :project, :subject, :invoicing_week, :prior_week, :persisted?
    attr_reader :entries, :timesheets, :line_items

    def initialize(invoice)
      @invoice = invoice
      @project = invoice.project
      @projects_timesheets = find_projects_timesheets(@invoice, @project)
      @timesheets = @projects_timesheets.map(&:timesheet).uniq
      @entries = @projects_timesheets.map(&:entries).flatten

      @line_items = LineItems.generate(invoice, entries, timesheets)
    end

    def you_were_just_submitted_to_harvest(harvest_id)
      now = Time.zone.now
      @invoice.update!(:harvest_id => harvest_id)
      @projects_timesheets.map { |pt| pt.update(:sent_to_harvest_at => now, :updated_at => now) }
    end

    def active_record_invoice
      @invoice
    end

  private

    def find_projects_timesheets(invoice, project)
      ( ProjectsTimesheet.for_week_and_project(invoice.prior_week, project) +
        ProjectsTimesheet.for_week_and_project(invoice.invoicing_week, project)
      ).reject {|pt| pt.timesheet.empty? }
    end
  end
end
