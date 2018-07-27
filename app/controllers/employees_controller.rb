class EmployeesController < ApplicationController
  before_action :find_employee_by_url_id, only: [:edit, :update, :destroy]

  def index
    @employees = Employee.all
  end

  def show
    case current_user.type
    when 'Admin'
      find_employee_by_url_id
      @roles = @employee.roles
    when 'Employee'
      @employee = Employee.find(current_user.id)
      @roles_projectmanager = @employee.roles.where(:role => "projectmanager")
      @roles_developer = @employee.roles.where(:role => "developer")
      @roles_tester = @employee.roles.where(:role => "tester")
    end
  end

  def new
    @employee = Employee.new
  end

  def create
    @employee = Employee.new(employee_params)
    if @employee.save
      redirect_to employee_path(@employee)
    else
      render 'new'
    end
  end

  def edit
  end

  def update
    if @employee.update(employee_params)
      redirect_to employee_path(@employee)
    else
      render 'edit'
    end
  end

  def destroy
    @employee.destroy
    redirect_to employees_path
  end

  private
  def employee_params
    params.require(:employee).permit(:first_name, :last_name, :username,
                                       :password, :email, :function, :attachment)
  end

  def find_employee_by_url_id
    @employee = Employee.find(params[:id])
  end
end
