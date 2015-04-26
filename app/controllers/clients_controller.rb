class ClientsController < ApplicationController
  before_filter :require_admin

  def index
    @clients = Client.all
  end

  def edit
    @client = Client.find(params[:id])
  end

  def update
    (client = Client.find(params[:id])).update!(params[:client].permit(:name, :active))
    flash[:info] = ["Information updated for #{client.name}!"]
    redirect_to edit_client_path(client)
  end
end
