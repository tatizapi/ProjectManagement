class ClientsController < ApplicationController
  def index
    @clients = Client.all
  end

  def new
    @client = Client.new
  end

  def create
    @client = Client.new(client_params)
    if @client.save
      redirect_to clients_path
    else
      render 'new'
    end
  end

  private
  def client_params
    params.require(:client).permit(:first_name, :last_name, :username,
                                    :password, :email, :picture)
  end
end
