class HomeController < ApplicationController
  def index
    redirect_to admin_index_path if current_user.admin
  end
end
