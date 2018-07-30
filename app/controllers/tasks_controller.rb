class TasksController < ApplicationController
  before_action :find_current_project, only: [:new, :create]

  #for developers dropdown
  before_action :get_developers, only: [:new, :create]

  #index and show are common for admin and employee
  before_action :setup_left_sidebar, only: [:new, :create]

  def new
    @task = Task.new
  end

  def create
    # begin
    #   Task.create!(task_params.merge(project_id: params[:project_id], status: "todo"))
    # rescue => e
    #   puts "!! e: #{e.inspect}"
    #   #render 'new'
    #   redirect_to new_project_task_path
    #   return false
    # end
    @task = Task.new(task_params.merge(project_id: params[:project_id], status: "todo"))
    if @task.save
      redirect_to project_path(@project)
    else
      render 'new'
    end
  end

  private
  def task_params
    params.require(:task).permit(:title, :description, :priority, {attachments: []},
                                  :project_id, :developers, :employee_id)
  end

  def find_current_project
    @project = Project.find(params[:project_id])
  end

  def get_developers
    @developers = @project.get_developers
  end

  def get_projects
    @projects = Project.all
  end

  def setup_left_sidebar
    case current_user.type
    when 'Admin'
      get_projects
    when 'Employee'
      @projects_projectmanager_role,
      @projects_developer_role,
      @projects_tester_role = Employee.get_employees_filtered_by_role(current_user.id)
    end
  end

end
