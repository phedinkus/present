class Invoice < ActiveRecord::Base
  belongs_to :project

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
