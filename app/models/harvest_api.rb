class HarvestApi
  def initialize
    @client = Harvest.hardy_client(
      Rails.application.config.harvest.subdomain,
      Rails.application.config.harvest.username,
      Rails.application.secrets.harvest_password
    )
  end

  def update_clients_and_projects!
    @client.clients.all.select(&:active?).each do |client|
      ActiveRecordConverter.upsert_client!(client)
    end

    @client.projects.all.select(&:active?).each do |project|
      ActiveRecordConverter.upsert_project!(project)
    end
  end

private

  module ActiveRecordConverter
    def self.upsert_client!(harvest_client)
      Client.find_or_create_by(:harvest_id => harvest_client.id).tap do |project|
        project.update(
          :name => harvest_client.name,
          :active => harvest_client.active?
        )
      end
    end

    def self.upsert_project!(harvest_project)
      Project.find_or_create_by(:harvest_id => harvest_project.id).tap do |project|
        project.update(
          :name => harvest_project.name,
          :active => harvest_project.active?,
          :client => Client.find_by(:harvest_id => harvest_project.client_id)
        )
      end
    end
  end
end
