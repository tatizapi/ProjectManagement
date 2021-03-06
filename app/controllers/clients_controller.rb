class ClientsController < ApplicationController
  before_action :find_client_by_id, only: [:show, :edit, :update, :destroy]
  before_action :get_clients, only: [:index, :show, :new, :create, :edit, :update]
  before_action :setup_left_sidebar, only: [:show]

  def index
  end

  def show
  end

  def new
    @client = Client.new
  end

  def create
    @client = Client.new(client_params)

    if @client.save
      redirect_to client_path(@client)
    else
      render 'new'
    end
  end

  def edit
  end

  def update
    if @client.update(client_params)
      redirect_to client_path(@client)
    else
      render 'edit'
    end
  end

  def destroy
    @client.destroy
    redirect_to clients_path
  end

  private

  def client_params
    params.require(:client).permit(:first_name, :last_name, :username, :password, :file, :email, :country, :company)
  end

  def find_client_by_id
    @client = Client.find(params[:id])
  end

  def get_clients
    @clients = Client.all
  end
end
