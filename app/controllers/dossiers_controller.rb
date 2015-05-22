class DossiersController < ApplicationController
  def index
    @dossiers = GathersDossiers.new.gather
  end
end
