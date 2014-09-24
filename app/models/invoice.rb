class Invoice < ActiveRecord::Base
  belongs_to :project

  def self.todo
    (new_invoices_that_need_to_be_sent_to_harvest + existing_invoices_that_need_to_be_sent_to_harvest).sort_by(&:invoicing_week).reverse
  end

  def self.new_invoices_that_need_to_be_sent_to_harvest
    ProjectsTimesheet.
      where(:sent_to_harvest_at => nil).
      joins(:timesheet).merge(Timesheet.current_and_past).
      joins(:project).merge(Project.invoiceable).
      select { |projects_timesheet| projects_timesheet.timesheet.week.invoice_week? }.
      map {|projects_timesheet| projects_timesheet.timesheet.week.ymd_hash.merge(:project => projects_timesheet.project) }.
      uniq.
      map { |invoice_options| Invoice.new(invoice_options) }
  end

  def self.existing_invoices_that_need_to_be_sent_to_harvest
    ProjectsTimesheet.outdated_in_harvest.map do |pt|
      Invoice.find_by(pt.timesheet.week.closest_invoice_week.ymd_hash.merge(:project => pt.project))
    end.compact.uniq
  end

  def subject
    "Consulting services from #{prior_week.beginning.to_s(:mdy)} to #{invoicing_week.end.to_s(:mdy)}"
  end

  def invoicing_week
    Week.new(Time.zone.local(year, month, day))
  end

  def prior_week
    invoicing_week.previous
  end

  def generate_for_harvest
    Present::Harvest::GeneratedInvoice.new(self)
  end
end
