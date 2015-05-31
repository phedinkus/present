module Seeds
  module Project
    def self.seed!
      [:paid_time_off, :holiday].each do |type|
        ::Project.find_or_create_by!(
          :name => type.to_s.titleize,
          :active => true,
          :weekly_rate => 0,
          :hourly_rate => 0,
          :rate_type => "weekly",
          :sticky => true,
          :billable => false
        )
      end
    end
  end
end
