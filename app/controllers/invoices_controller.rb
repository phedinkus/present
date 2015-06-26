class InvoicesController < ApplicationController
  before_filter :require_admin
  before_action :generate_invoice_from_params, :only => [:create, :update, :show, :send_to_harvest]

  def todo
    @week = if [params[:year], params[:month], params[:day]].all?(&:present?)
      Week.for(params[:year], params[:month], params[:day])
    else
      Week.now
    end.previous_invoice_week

    @invoice_todos = InvoiceTodos.gather(@week)
    @timesheet_status = Answers::TimesheetStatus.status_for(@week)
  end

  def new
    @invoice = Invoice.new(Week.now.previous_invoice_week.ymd_hash)
  end

  def create
    redirect_to @invoice.active_record_invoice
  end

  def update
    redirect_to @invoice.active_record_invoice
  end

  def show
  end

  def send_to_harvest
    Present::Harvest::SendInvoice.new.send!(@invoice)
    flash[:info] = ["Sent invoice to Harvest!"]
    redirect_to @invoice.active_record_invoice
  end

private

  def generate_invoice_from_params
    @invoice = if params[:id].present?
      Invoice.find(params[:id]).generate_for_harvest
    else
      week = Week.new(Time.zone.parse(params[:invoice][:invoicing_week]))
      project = Project.find(params[:invoice][:project_id])
      Invoice.find_or_create_by(week.ymd_hash.merge(:project => project)).generate_for_harvest
    end
  end
end
