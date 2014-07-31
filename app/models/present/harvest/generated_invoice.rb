module Present::Harvest
  class GeneratedInvoice
    extend Forwardable
    def_delegators :@invoice, :id, :harvest_id, :project, :subject, :invoicing_week, :prior_week
    attr_reader :entries, :timesheets, :line_items

    def initialize(invoice)
      @invoice = invoice
      @project = invoice.project
      @entries = Entry.non_zero_entries_for_week_and_project(@invoice.prior_week, @project) +
        Entry.non_zero_entries_for_week_and_project(@invoice.invoicing_week, @project)
      @timesheets = @entries.map(&:timesheet).uniq
      @line_items = LineItems.generate(invoice, entries, timesheets)
    end

    def you_were_just_submitted_to_harvest(harvest_id)
      now = Time.zone.now
      @invoice.update!(:harvest_id => harvest_id)
      ProjectsTimesheet.for(@project, @timesheets).map { |pt| pt.update(:sent_to_harvest_at => now) }
    end

    def active_record_invoice
      @invoice
    end
  end
end
