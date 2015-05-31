class SystemConfiguration < ActiveRecord::Base
  belongs_to :default_location, :class_name => "Location"

  def self.instance
    SystemConfiguration.first || SystemConfiguration.create!
  end

  def self.reference_invoice_week
    @reference_invoice_week ||= begin
      config = instance
      if [config.reference_invoice_year, config.reference_invoice_month, config.reference_invoice_day].all?(&:present?)
        Week.for(config.reference_invoice_year, config.reference_invoice_month, config.reference_invoice_day)
      end
    end
  end
end
