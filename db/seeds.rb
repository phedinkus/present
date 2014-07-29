# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

puts "Upserting clients and projects from Harvest into Present's database"
HarvestApi.new.update_clients_and_projects!
puts <<-LOG
  Harvest Export complete:
  ------------------------

    Active Clients: #{Client.where(:active => true).count}
    Active Projects: #{Project.where(:active => true).count}

LOG
