class EmployeesController < ApplicationController
  def index
    @employees = Employee.all
  end

  def show
    @employee = Employee.find(current_user.id)
    @roles_projectmanager = @employee.roles.where(:role => "projectmanager")
    @roles_developer = @employee.roles.where(:role => "developer")
    @roles_tester = @employee.roles.where(:role => "tester")
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
      redirect_to employees_path
    else
      render 'edit'
    end
  end

  def destroy
    @employee = Employee.find(params[:id])
    @employee.destroy
    redirect_to employees_path
  end

  def add_new_project_employees
    # @project = Project.find(params[:id])
    #
    # if !params[:developers].nil?
    #   employees_ids_array = params[:developers][:id]
    #   employees_ids_array.each do |employee_id|
    #     employee = Employee.find(employee_id)
    #     role_params = Hash.new
    #     role_params[:project_id] = @project.id
    #     role_params[:employee_id] = employee_id
    #     role_params[:role] = "developer"
    #     @role = Role.new(role_params)
    #     @role.save
    #   end
    #   redirect_to details_project_path
    # else
    #   if !params[:testers].nil?
    #     employees_ids_array = params[:testers][:id]
    #     employees_ids_array.each do |employee_id|
    #       employee = Employee.find(employee_id)
    #       role_params = Hash.new
    #       role_params[:project_id] = @project.id
    #       role_params[:employee_id] = employee_id
    #       role_params[:role] = "tester"
    #       @role = Role.new(role_params)
    #       @role.save
    #     end
    #   end
    #   redirect_to details_project_path
    # end
  end

  private
  def employee_params
    params.require(:employee).permit(:first_name, :last_name, :username,
                                       :password, :email, :function, :attachment)
  end
end
