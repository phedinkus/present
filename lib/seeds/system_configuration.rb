module Seeds
  module SystemConfiguration
    def self.seed!
      ::SystemConfiguration.instance.update!(
        :reference_invoice_year => 2013,
        :reference_invoice_month => 11,
        :reference_invoice_day => 24,
        :default_location =>
          ::Location.find_by(:city => "Columbus", :state => "OH")
      )
    end
  end
end

