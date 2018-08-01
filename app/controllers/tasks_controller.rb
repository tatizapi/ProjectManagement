class TasksController < ApplicationController
  before_action :find_task_by_id, only: [:edit, :update, :destroy]
  before_action :find_current_project, only: [:new, :create, :destroy, :edit, :update]

  #for developers dropdown
  before_action :get_developers, only: [:new, :create, :edit, :update]

  #index and show are common for admin and employee
  before_action :setup_left_sidebar, only: [:new, :create, :edit, :update]

  def new
    @task = Task.new
  end

  def create
    @task = Task.new(task_params.merge(project_id: params[:project_id], status: "todo",
                      created_at: DateTime.current))
    if @task.save
      redirect_to project_dashboard_index_path(@project)
    else
      render 'new'
    end
  end

  def edit

  end

  def update
    if @task.update(task_params)
      redirect_to project_dashboard_index_path(@project)
    else
      render 'edit'
    end
  end

  def destroy
    @task.destroy
    redirect_to project_dashboard_index_path(@project)
  end

  private

  def task_params
    params.require(:task).permit(:title, :description, :priority, {attachments: []},
                                  :project_id, :developers, :employee_id)
  end

  def find_task_by_id
    @task = Task.find(params[:id])
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
