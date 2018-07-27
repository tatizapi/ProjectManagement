class TasksController < ApplicationController
  before_action :find_current_project, only: [:new, :create]

  def new
    @task = Task.new
    @project_developers_roles = @project.roles.where(:role => "developer")
  end

  def create
    @task = Task.new(task_params)
    @project.tasks << @task
    if params[:task][:developer_id] != ""
      @employee = Employee.find(params[:task][:developer_id])
      @employee.tasks << @task
    end
    @task.status = "todo"

    if @task.save
      redirect_to project_path(@project)
    else
      redirect_to new_project_task_path
    end
  end

  private
  def task_params
    params.require(:task).permit(:title, :description, :priority,
                                  {attachments: []}, :project_id, :developers)
  end

  def find_current_project
    @project = Project.find(params[:project_id])
  end
end
