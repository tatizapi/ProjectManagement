class DashboardController < ApplicationController
  before_action :find_current_project, only: [:index]

  def index
    @tasks_todo = @project.tasks.where(status: 'todo')
    @tasks_inprogress = @project.tasks.where(status: 'inprogress')
    @tasks_complete = @project.tasks.where(status: 'complete')
    @tasks_done = @project.tasks.where(status: 'done')

    #left sidebar
    case current_user.type
    when "Admin"
      @projects = Project.all
    when "Employee"
      @projects_projectmanager_role,
      @projects_developer_role,
      @projects_tester_role = Employee.get_employees_filtered_by_role(current_user.id)
    end

  end

  private

  def find_current_project
    @project = Project.find(params[:project_id])
  end

end
