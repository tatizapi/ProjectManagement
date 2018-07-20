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

end
