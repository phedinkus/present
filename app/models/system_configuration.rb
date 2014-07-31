class SystemConfiguration < ActiveRecord::Base
  def self.instance
    SystemConfiguration.first || SystemConfiguration.create!
  end

  def reference_invoice_week
    Week.for(reference_invoice_year, reference_invoice_month, reference_invoice_day)
  end
end
