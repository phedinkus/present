module Present::Harvest
  class GeneratedInvoice
    extend Forwardable
    def_delegators :@invoice, :id, :harvest_id, :project, :subject, :invoicing_week, :prior_week
    attr_reader :entries, :timesheets, :line_items

    def initialize(invoice)
      @invoice = invoice
      @project = invoice.project
      @timesheets = (Timesheet.for(@invoice.prior_week, @project) + Timesheet.for(@invoice.invoicing_week, @project)).reject(&:empty?)
      @entries = @timesheets.map(&:entries).flatten.uniq
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
