class TasksController < ApplicationController
  def new
    @task = Task.new
    @project = Project.find(params[:project_id])
    @project_developers_roles = @project.roles.where(:role => "developer")
  end

  def create
    @task = Task.new(task_params)
    @project = Project.find(params[:project_id])
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
end
