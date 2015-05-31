puts "Upserting clients and projects from Harvest into Present's database"
Seeds::Harvest.seed!

puts <<-LOG
  Harvest Import complete:
  ------------------------

  Active Clients: #{Client.where(:active => true).count}
  Active Projects: #{Project.where(:active => true).count}

LOG

puts "Upserting special projects"
Seeds::Project.seed!

puts "Upserting locations"
Seeds::Location.seed!

puts "Updating System Configuration"
Seeds::SystemConfiguration.seed!
