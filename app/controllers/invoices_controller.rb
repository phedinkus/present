class InvoicesController < ApplicationController
  before_filter :require_admin

  def new
  end

  def create
    week = Week.new(Time.zone.parse(params[:invoicing_week]))
    project = Project.find(params[:project_id])
    invoice = Invoice.find_or_create_by(week.ymd_hash.merge(:project => project))

    HarvestApi.new.update_invoice!(invoice)

    redirect_to invoice
  end

  def update
    invoice = Invoice.find(params[:id])
    HarvestApi.new.update_invoice!(invoice)
    redirect_to invoice
  end

  def show
    @invoice = Invoice.find(params[:id])
  end
end
