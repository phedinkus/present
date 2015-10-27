module Present::Harvest
  class CreationWrapper
    HARVEST_CREATION_CLASSES = {
      project: Present::Harvest::CreateProject,
      client:  Present::Harvest::CreateClient
    }

    def create!(operation, target)
      target.class.transaction do
        begin
          target.save!
          HARVEST_CREATION_CLASSES[operation].new.create!(target)
        rescue
          raise ActiveRecord::Rollback
        end
      end
    end
  end
end
