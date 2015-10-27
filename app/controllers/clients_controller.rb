class ClientsController < ApplicationController
  before_filter :require_admin

  def index
    @clients = Client.order('LOWER(name)')
  end

  def new
    @client = Client.new(:active => true)
    render :edit
  end

  def create
    @client = Client.new(client_params)

    Present::Harvest::CreationWrapper.new.create!(:client, @client)

    respond_to_harvest_creation(@project, clients_path)
  end

  def edit
    @client = Client.find(params[:id])
  end

  def update
    (client = Client.find(params[:id])).update!(client_params)
    flash[:info] = ["Information updated for #{client.name}!"]
    redirect_to edit_client_path(client)
  end

private

  def client_params
    params[:client].permit(:name, :active)
  end
end
