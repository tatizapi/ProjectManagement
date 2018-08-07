class DashboardController < ApplicationController
  before_action :find_current_project, only: [:index]
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
      #update_attributes
      #task.update(:status => "inprogess", :started_at)
      task.update_column(:status, "inprogress")
      task.update_column(:started_at, Time.now)
    when "inprogress"
      task.update_column(:status, "complete")
      task.update_column(:completed_at, Time.now)
    when "complete"
      if params[:set_todo]
        task.update_column(:status, "todo")
      else
        task.update_column(:status, "done")
        task.update_column(:ended_at, Time.now)
      end
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
