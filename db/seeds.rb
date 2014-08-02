puts "Initializing System Configuration"
SystemConfiguration.instance.update!(
  :reference_invoice_year => 2013,
  :reference_invoice_month => 11,
  :reference_invoice_day => 24
)

puts "Upserting clients and projects from Harvest into Present's database"
Present::Harvest::Api.new.update_clients_and_projects!
puts <<-LOG
  Harvest Export complete:
  ------------------------

    Active Clients: #{Client.where(:active => true).count}
    Active Projects: #{Project.where(:active => true).count}

LOG
