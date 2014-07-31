class Invoice < ActiveRecord::Base
  belongs_to :project

  def self.todo
    new_invoices_that_need_to_be_sent_to_harvest + existing_invoices_that_need_to_be_sent_to_harvest
  end

  def self.new_invoices_that_need_to_be_sent_to_harvest
    ProjectsTimesheet
      .where(:sent_to_harvest_at => nil)
      .joins(:timesheet).merge(Timesheet.current_and_past)
      .map do |projects_timesheet|
        Invoice.new(projects_timesheet.timesheet.week.ymd_hash.merge(:project => projects_timesheet.project))
      end
  end

  def self.existing_invoices_that_need_to_be_sent_to_harvest
    Invoice.joins(:project => {:projects_timesheets => [:timesheet, :entries]})
      .where("projects_timesheets.sent_to_harvest_at < timesheets.updated_at OR projects_timesheets.sent_to_harvest_at < entries.updated_at")
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
