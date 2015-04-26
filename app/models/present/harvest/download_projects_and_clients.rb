module Present::Harvest
  class DownloadProjectsAndClients
    def initialize
      @connection = Connection.create
    end

    def download!
      @connection.clients.all.select(&:active?).each do |client|
        upsert_client!(client)
      end

      @connection.projects.all.select(&:active?).each do |project|
        upsert_project!(project)
      end
    end

  private

    def upsert_client!(harvest_client)
      Client.find_or_create_by(:harvest_id => harvest_client.id).tap do |project|
        project.update!(
          :name => harvest_client.name,
          :active => harvest_client.active?
        )
      end
    end

    def upsert_project!(harvest_project)
      Project.find_or_create_by(:harvest_id => harvest_project.id).tap do |project|
        project.update!(
          :name => harvest_project.name,
          :active => harvest_project.active?,
          :client => Client.find_by(:harvest_id => harvest_project.client_id)
        )
      end
    end
  end
end
