class SystemConfiguration < ActiveRecord::Base
  belongs_to :default_location, :class_name => "Location"

  def self.instance
    SystemConfiguration.first || SystemConfiguration.create!
  end

  def reference_invoice_week
    return unless [reference_invoice_year, reference_invoice_month, reference_invoice_day].all?(&:present?)
    Week.for(reference_invoice_year, reference_invoice_month, reference_invoice_day)
  end
end
