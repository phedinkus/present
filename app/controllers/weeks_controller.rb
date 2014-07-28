class WeeksController < ApplicationController
  def current
    @week = Week.now
    render :show
  end

  def show
    @week = Week.for(params[:year], params[:ordinal])

  end
end
