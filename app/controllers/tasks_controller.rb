class TasksController < ApplicationController
  before_action :find_current_project, only: [:new, :create]
  #before_action :get_employees_filtered_by_role, only: [:new, :create]

  def new
    @task = Task.new
    @project_developers_roles = @project.roles.where(:role => "developer")

    @projects = Project.all
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
    @project_developers_roles = @project.roles.where(:role => "developer")
    @task = Task.new(task_params.merge(project_id: params[:project_id], status: "todo"))
    if @task.save
      redirect_to project_path(@project)
    else
      render 'new'
    end
  end

  private
  def task_params
    params.require(:task).permit(:title, :description, :priority,
                                  {attachments: []}, :project_id, :developers, :employee_id)
  end

  def find_current_project
    @project = Project.find(params[:project_id])
  end

  def get_employees_filtered_by_role
    @projectmanager_roles = Employee.find(current_user.id).roles.where(:role => "projectmanager")
    @developer_roles = Employee.find(current_user.id).roles.where(:role => "developer")
    @tester_roles = Employee.find(current_user.id).roles.where(:role => "tester")
  end

end
