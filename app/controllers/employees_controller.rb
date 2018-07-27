class EmployeesController < ApplicationController
  before_action :find_employee_by_url_id, only: [:show, :edit, :update, :destroy]
  before_action :get_employees, only: [:index, :create, :show, :edit, :new]

  def index
  end

  def show
    @roles = @employee.roles
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

  def get_employees
    @employees = Employee.all
  end
end
