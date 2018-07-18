class ClientsController < ApplicationController
  def index
    @clients = Client.all
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

  private
  def client_params
    params.require(:client).permit(:first_name, :last_name, :username, :password,
                                    :email, :picture, :country, :company)
  end

  def upload
    uploaded_io = params[:client][:picture]
    File.open(Rails.root.join('public', 'uploads',
              uploaded_io.original_filename), 'wb') do |file|
      file.write(uploaded_io.read)
    end
  end
end
