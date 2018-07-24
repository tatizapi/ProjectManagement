class TasksController < ApplicationController
  def new
    @task = Task.new

    #nu sunt sigura daca partea de aici arata ok avand in vedere ca e in index
    @project = Project.find(params[:project_id])
    project_developers_roles = @project.roles.where(:role => "developer")
    @project_developers = []
    project_developers_roles.each do |dev_role|
      @project_developers.push(Employee.find(dev_role.employee_id))
    end

  end

  def create
    @task = Task.new(task_params)
    @project = Project.find(params[:project_id])
    @project.tasks << @task
    @employee = Employee.find(params[:task][:developers][:developer_id])
    @employee.tasks << @task
    @task.status = "todo"

    if @task.save
      redirect_to project_path(@project)
    else
      redirect_to new_task_path
    end
  end

  private
  def task_params
    params.require(:task).permit(:title, :description, :priority,
                                  {attachments: []}, :project_id, :developers)
  end
end
