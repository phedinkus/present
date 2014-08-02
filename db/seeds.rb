puts "Initializing System Configuration"
SystemConfiguration.instance.update!(
  :reference_invoice_year => 2013,
  :reference_invoice_month => 11,
  :reference_invoice_day => 24
)

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
    :special_type => type.to_s
  )
end
