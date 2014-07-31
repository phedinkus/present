class InvoicesController < ApplicationController
  before_filter :require_admin

  def new
    @invoice = Invoice.new(Week.now.previous_invoice_week.ymd_hash)
  end

  def create
    week = Week.new(Time.zone.parse(params[:invoice][:invoicing_week]))
    project = Project.find(params[:invoice][:project_id])
    invoice = Invoice.find_or_create_by(week.ymd_hash.merge(:project => project)).generate_for_harvest

    Present::Harvest::Api.new.update_invoice!(invoice)

    redirect_to invoice.active_record_invoice
  end

  def update
    invoice = Invoice.find(params[:id]).generate_for_harvest
    Present::Harvest::Api.new.update_invoice!(invoice)
    redirect_to invoice.active_record_invoice
  end

  def show
    @invoice = Invoice.find(params[:id]).generate_for_harvest
  end

  def todo
    @invoices = Invoice.todo.map(&:generate_for_harvest)
  end
end
