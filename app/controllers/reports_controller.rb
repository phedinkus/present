class ReportsController < ApplicationController
  before_filter :require_admin

  def new
  end

  def show
    start_date = Date.parse(params[:start_date])
    end_date = Date.parse(params[:end_date])

    render :csv => Reports::IncomeByLocation.as_csv(start_date, end_date),
      :filename => "#{start_date}-#{end_date}-income-by-location"
  end
end
