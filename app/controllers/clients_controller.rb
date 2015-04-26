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
    @client = Client.new(params[:client].permit(:name, :active))
    Client.transaction do
      begin
        @client.save!
        Present::Harvest::CreateClient.new.create!(@client)
      rescue
        raise ActiveRecord::Rollback
      end
    end
    if @client.id?
      flash[:info] = ["Client #{@client.name} created!"]
      redirect_to clients_path
    else
      flash[:error] = ["Client creation failed!"] + @client.errors.full_messages
      render :edit
    end
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
