include ActionView::Helpers::NumberHelper

module Present::Harvest
  class SendInvoice
    def initialize
      @connection = Connection.create
    end

    def send!(present_invoice)
      harvest_invoice_for(present_invoice, @connection).tap do |harvest_invoice|
        persist_invoice!(harvest_invoice, present_invoice, @connection)
      end
    end

  private

    def harvest_invoice_for(present_invoice, conn)
      find_or_create(present_invoice, conn).tap do |harvest_invoice|
        harvest_invoice.due_at_human_format = "net 30"
        if present_invoice.project.manually_invoiced?
          harvest_invoice.subject = "Consulting Services"
          harvest_invoice.line_items = []
          harvest_invoice.notes = "Thank you!"
        else
          harvest_invoice.subject = present_invoice.subject
          harvest_invoice.line_items = present_invoice.line_items.map {|h| Harvest::LineItem.new(h) }
          harvest_invoice.notes = notes_for(present_invoice)
        end
      end
    end

    def find_or_create(present_invoice, conn)
      find_existing_invoice(present_invoice.harvest_id, conn) || Harvest::Invoice.new(:client_id => present_invoice.project.client.harvest_id)
    end

    def find_existing_invoice(id, conn)
      return unless id.present?
      conn.invoices.find(id)
    rescue Harvest::NotFound
    end

    def persist_invoice!(harvest_invoice, present_invoice, conn)
      persisted_harvest_invoice = if harvest_invoice.id?
        conn.invoices.update(harvest_invoice)
      else
        conn.invoices.create(harvest_invoice)
      end
      present_invoice.you_were_just_submitted_to_harvest(persisted_harvest_invoice.id)
    end

    def notes_for(present_invoice)
      "Thank you!\n\n"\
      "Unit Price and Quantity reflect a #{present_invoice.rate_type} rate of #{number_to_currency(present_invoice.unit_price)}"
    end
  end
end
