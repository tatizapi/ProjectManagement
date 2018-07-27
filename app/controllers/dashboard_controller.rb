class DashboardController < ApplicationController
  before_action :find_current_project, only: [:index]

  def index
    @tasks_todo = @project.tasks.where(status: 'todo')
    @tasks_inprogress = @project.tasks.where(status: 'inprogress')
    @tasks_complete = @project.tasks.where(status: 'complete')
    @tasks_done = @project.tasks.where(status: 'done')

    get_employees_filtered_by_role
  end

  private
  def find_current_project
    @project = Project.find(params[:project_id])
  end

  def get_employees_filtered_by_role
    @projectmanager_roles = Employee.find(current_user.id).roles.where(:role => "projectmanager")
    @developer_roles = Employee.find(current_user.id).roles.where(:role => "developer")
    @tester_roles = Employee.find(current_user.id).roles.where(:role => "tester")
  end

end
