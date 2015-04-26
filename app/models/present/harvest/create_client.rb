module Present::Harvest
  class CreateClient
    def initialize
      @connection = Connection.create
    end

    def create!(ar_client)
      @connection.clients.create(:name => ar_client.name, :active => ar_client.active).tap do |h_client|
        ar_client.update!(:harvest_id => h_client.id)
      end
    rescue => e
      ar_client.errors.add(:id, "Harvest failed with: #{e.message}")
      raise e
    end
  end
end
