module Present::Harvest
  class Api
    def initialize
      @client = Harvest.hardy_client(
        :subdomain => Rails.application.config.harvest.subdomain,
        :username => Rails.application.config.harvest.username,
        :password => Rails.application.secrets.harvest_password
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

    def update_invoice!(present_invoice)
      ActiveRecordConverter.harvest_invoice_for(present_invoice, @client).tap do |harvest_invoice|
        harvest_invoice.subject = present_invoice.subject
        harvest_invoice.due_at_human_format = "net 30"
        harvest_invoice.line_items = present_invoice.line_items.map {|h| Harvest::LineItem.new(h) }
        ActiveRecordConverter.persist_invoice!(harvest_invoice, present_invoice, @client)
      end
    end

  private

    module ActiveRecordConverter
      def self.upsert_client!(harvest_client)
        Client.find_or_create_by(:harvest_id => harvest_client.id).tap do |project|
          project.update!(
            :name => harvest_client.name,
            :active => harvest_client.active?
          )
        end
      end

      def self.upsert_project!(harvest_project)
        Project.find_or_create_by(:harvest_id => harvest_project.id).tap do |project|
          project.update!(
            :name => harvest_project.name,
            :active => harvest_project.active?,
            :client => Client.find_by(:harvest_id => harvest_project.client_id)
          )
        end
      end

      def self.harvest_invoice_for(present_invoice, conn)
        find_existing_invoice(present_invoice.harvest_id, conn) || Harvest::Invoice.new(:client_id => present_invoice.project.client.harvest_id)
      end

      def self.find_existing_invoice(id, conn)
        return unless id.present?
        conn.invoices.find(id)
      rescue Harvest::NotFound
      end

      def self.persist_invoice!(harvest_invoice, present_invoice, conn)
        persisted_harvest_invoice = if harvest_invoice.id?
          conn.invoices.update(harvest_invoice)
        else
          conn.invoices.create(harvest_invoice)
        end
        present_invoice.you_were_just_submitted_to_harvest(persisted_harvest_invoice.id)
      end
    end
  end
end
