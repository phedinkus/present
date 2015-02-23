puts "Upserting clients and projects from Harvest into Present's database"
Present::Harvest::Api.new.update_clients_and_projects!
puts <<-LOG
  Harvest Import complete:
  ------------------------

    Active Clients: #{Client.where(:active => true).count}
    Active Projects: #{Project.where(:active => true).count}

LOG

puts "Upserting special projects"
[:vacation, :holiday].each do |type|
  Project.find_or_create_by!(
    :name => type.to_s.titleize,
    :active => true,
    :weekly_rate => 0,
    :hourly_rate => 0,
    :rate_type => "weekly",
    :sticky => true,
    :billable => false
  )
end

puts "Upserting locations"
[
  {:city => "Oakland", :state => "CA" },
  {:city => "Denver", :state => "CO" },
  {:city => "Broomfield", :state => "CO" },
  {:city => "Yorktown", :state => "IN" },
  {:city => "Chicago", :state => "IL" },
  {:city => "Detroit", :state => "MI" },
  {:city => "Grand Rapids", :state => "MI" },
  {:city => "Columbus", :state => "OH" },
  {:city => "Westerville", :state => "OH" },
  {:city => "Powell", :state => "OH" },
  {:city => "Hilliard", :state => "OH" },
  {:city => "Johnstown", :state => "OH" },
  {:city => "Jonestown", :state => "PA" },
  {:city => "Salt Lake City", :state => "UT" },
  {:city => "Virginia Beach", :state => "VA" },
  {:city => "Madison", :state => "WI" },
  {:city => "Ottawa", :state => "ON" },
  {:city => "Saskatoon", :state => "SK" }
].each do |location|
  Location.find_or_create_by!(
    :city => location[:city],
    :state => location[:state]
  )
end

puts "Updating System Configuration"
SystemConfiguration.instance.update!(
  :reference_invoice_year => 2013,
  :reference_invoice_month => 11,
  :reference_invoice_day => 24,
  :default_location => Location.find_by(:city => "Columbus", :state => "OH")
)
