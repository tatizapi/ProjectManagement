class HomeController < ApplicationController
  def index
    redirect_to admin_index_path if current_user.type == "Admin"
    redirect_to clients_path if current_user.type == "Client"
    redirect_to employee_path(current_user.id) if current_user.type == "Employee"
  end
end
