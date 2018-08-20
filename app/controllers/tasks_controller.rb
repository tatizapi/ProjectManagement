class TasksController < ApplicationController
  before_action :find_task_by_id, only: [:show, :edit, :update, :destroy, :delete_attachment]
  before_action :find_current_project, only: [:new, :create, :show, :edit, :update, :destroy]

  #for developers dropdown
  before_action :get_developers, only: [:new, :create, :edit, :update]

  #index and show are common for admin and employee
  before_action :setup_left_sidebar, only: [:new, :create, :show, :edit, :update]

  def new
    @task = Task.new(owner: params[:owner], bug: params[:bug], parent_task: params[:parent_task])
    get_task_developer #for dropdown when a bug is created
  end

  def create
    @task = Task.new(task_params.merge(project_id: params[:project_id], status: "todo", created_at: DateTime.current, bug: params[:task][:bug], parent_task: params[:task][:parent_task]))
    if @task.save
      add_files
      redirect_to project_dashboard_index_path(@project)
    else
      render 'new'
    end
  end

  def show
  end

  def edit
  end

  def update
    if @task.update(task_params)
      add_files
      redirect_to project_dashboard_index_path(@project)
    else
      render 'edit'
    end
  end

  def destroy
    @task.destroy
    redirect_to project_dashboard_index_path(@project)
  end

  def delete_attachment
    attachment = Attachment.find(params[:attachment_id])
    attachment.destroy
    redirect_to edit_project_task_path(@task.project, @task)
  end

  private

  def task_params
    params.require(:task).permit(:title, :description, :priority, {attachments: []}, :project_id, :developers, :employee_id, :owner, :bug)
  end

  def permit_files
    params.require(:task).permit({files: []})
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

  def get_task_developer
    if params[:parent_task] #only when a subtask is created
      @developer = Employee.find(Task.find(params[:parent_task]).employee_id)
    end
  end

  def add_files
    permit_files
    save_files(@task, params[:task][:files])
  end
end
