class DashboardController < ApplicationController
  before_action :find_current_project, only: [:index, :change_status]
  before_action :get_project_tasks, only: [:index]

  def index
    #left sidebar
    case current_user.type
    when "Admin"
      @projects = Project.all
    when "Employee"
      @projects_projectmanager_role, @projects_developer_role, @projects_tester_role = Employee.get_employees_filtered_by_role(current_user.id)
    when 'Client'
      get_client_projects
    end
  end

  def change_status
    task = Task.find(params[:task_id])

    case task.status
    when "todo"
      #started_at is set only once, first time it goes to "inprogress"
      task.started_at.nil? ? task.update(status: "inprogress", started_at: Time.now) : task.update(status: "inprogress")
    when "inprogress"
      params[:back] ? status = "todo" : status = "complete"
      status == "complete" ? task.update(status: status, completed_at: Time.now) : task.update(status: status)
    when "complete"
      if params[:back] && (current_user.is_developer?(@project) || current_user.type == "Admin" )
        status = "inprogress"
      elsif params[:back] && current_user.is_tester?(@project)
        status = "todo"
      else
        status = "done"
      end
      status == "done" ? task.update(status: status, ended_at: Time.now) : task.update(status: status)
    when "done"
      task.update(status: "complete")
    end
  end

  def download
    send_file "#{Rails.root}/public#{params[:attachment].gsub('%2B', '+')}", disposition: 'attachment'
  end

  private

  def find_current_project
    @project = Project.find(params[:project_id])
  end

  def get_client_projects
    @projects = Client.find(current_user.id).projects
  end

  def get_project_tasks
    @tasks = @project.tasks.filter(params[:filter], current_user.id)
  end

end
