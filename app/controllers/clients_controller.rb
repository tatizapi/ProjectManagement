class ClientsController < ApplicationController
  def index
    @clients = Client.all
  end

  def show
  end

  def new
    @client = Client.new
  end


  def create
    upload

    @client = Client.new(client_params)
    @client.picture = File.basename(params[:client][:picture].original_filename)
    if @client.save
      redirect_to clients_path
    else
      render 'new'
    end
  end

  def edit
    @client = Client.find(params[:id])
  end

  def update
    @client = Client.find(params[:id])
    if !params[:client][:picture].nil?
      @client.picture = File.basename(params[:client][:picture].original_filename)
      params[:client].delete(:picture)
    end
    if @client.update(client_params)
      redirect_to clients_path
    else
      render 'new'
    end
  end

  def destroy
    @client = Client.find(params[:id])
    @client.destroy
    redirect_to clients_path
  end

  private
  def client_params
    params.require(:client).permit(:first_name, :last_name, :username, :password,
                                    :email, :country, :company)
  end

  def upload
    uploaded_io = params[:client][:picture]
    File.open(Rails.root.join('public', 'uploads',
              uploaded_io.original_filename), 'wb') do |file|
      file.write(uploaded_io.read)
    end
  end
end
