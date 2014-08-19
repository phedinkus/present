class SystemConfiguration < ActiveRecord::Base
  def self.instance
    SystemConfiguration.first || SystemConfiguration.create!(
      :reference_invoice_year => 1980,
      :reference_invoice_month => 1,
      :reference_invoice_day => 1
    )
  end

  def reference_invoice_week
    Week.for(reference_invoice_year, reference_invoice_month, reference_invoice_day)
  end
end
