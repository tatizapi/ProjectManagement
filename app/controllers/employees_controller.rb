class EmployeesController < ApplicationController
  def index
    current_employee = current_user.id
    @employee = Employee.find(current_employee)
    @roles_projectmanager = @employee.roles.where(:role => "projectmanager")
    @roles_developer = @employee.roles.where(:role => "developer")
    @roles_tester = @employee.roles.where(:role => "tester")
  end

  def details_project
    @project = Project.find(params[:id])

    @project_testers_roles = @project.roles.where(:role => "tester")
    @project_developers_roles = @project.roles.where(:role => "developer")

    @available_employees = Employee.all - @project.employees
  end

  def add_new_project_employees
    @project = Project.find(params[:id])

    if !params[:developers].nil?
      employees_ids_array = params[:developers][:id]
      employees_ids_array.each do |employee_id|
        employee = Employee.find(employee_id)
        role_params = Hash.new
        role_params[:project_id] = @project.id
        role_params[:employee_id] = employee_id
        role_params[:role] = "developer"
        @role = Role.new(role_params)
        @role.save
      end
      redirect_to details_project_path
    else
      if !params[:testers].nil?
        employees_ids_array = params[:testers][:id]
        employees_ids_array.each do |employee_id|
          employee = Employee.find(employee_id)
          role_params = Hash.new
          role_params[:project_id] = @project.id
          role_params[:employee_id] = employee_id
          role_params[:role] = "tester"
          @role = Role.new(role_params)
          @role.save
        end
      end
      redirect_to details_project_path
    end

  end

  def add_new_testers
    @project = Project.find(params[:id])
  end

end
