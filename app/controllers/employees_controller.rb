class EmployeesController < ApplicationController
  def index
    @employees = Employee.all
  end

  def show
    case current_user.type
    when 'Admin'
      @employee = Employee.find(params[:id])
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
      redirect_to employees_path
    else
      render 'new'
    end
  end

  def edit
    @employee = Employee.find(params[:id])
  end

  def update
    @employee = Employee.find(params[:id])
    if @employee.update(employee_params)
      redirect_to employee_path(@employee)
    else
      render 'edit'
    end
  end

  def destroy
    @employee = Employee.find(params[:id])
    @employee.destroy
    redirect_to employees_path
  end

  private
  def employee_params
    params.require(:employee).permit(:first_name, :last_name, :username,
                                       :password, :email, :function, :attachment)
  end
end
