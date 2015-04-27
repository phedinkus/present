module Present::Harvest
  class CreateProject
    def initialize
      @connection = Connection.create
    end

    def create!(ar_project)
      return unless ar_project.billable?
      @connection.projects.create(
        :client_id => ar_project.client.harvest_id,
        :name => ar_project.name,
        :active => ar_project.active,
        :billable => ar_project.billable
      ).tap do |h_project|
        ar_project.update!(:harvest_id => h_project.id)
      end
    rescue => e
      ar_project.errors.add(:id, "Harvest failed with: #{e.message}")
      raise e
    end
  end
end
