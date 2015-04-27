module Present::Harvest
  class Connection < SimpleDelegator
    def self.create
      new Harvest.hardy_client(
        :subdomain => Rails.application.config.harvest.subdomain,
        :username => Rails.application.config.harvest.username,
        :password => Rails.application.secrets.harvest_password
      )
    end
  end
end
