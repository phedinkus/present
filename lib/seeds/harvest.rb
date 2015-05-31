module Seeds
  module Harvest
    def self.seed!
      Present::Harvest::DownloadProjectsAndClients.new.download!
    end
  end
end
