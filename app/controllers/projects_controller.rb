class ProjectsController < ApplicationController
  before_action :find_project_by_url_id, only: [:show, :edit, :update, :destroy]
  before_action :get_employees, only: [:new, :edit]

  def index
    @projects = Project.all
  end

  def show
    @project_testers_roles = @project.roles.where(:role => "tester")
    @project_developers_roles = @project.roles.where(:role => "developer")
  end

  def new
    @project = Project.new
  end

  def create
    @project = Project.new(project_params)
    if !@project.save
      render 'new'
    end

    add_projectmanager_role
    redirect_to project_path(@project)
  end

  def edit
  end

  def update
    update_projectmanager_role
    if @project.update(project_params)
      redirect_to project_path(@project)
    else
      render 'edit'
    end
  end

  def destroy
    @project.destroy
    redirect_to projects_path
  end

  #in lucru
  def add_employees
    @project = Project.find(params[:id])
    @available_employees = Employee.all - @project.employees
  end

  def add_developers
    @project = Project.find(params[:id])

    if !params[:developer_ids].nil?
      params[:developer_ids].each do |developer_id|
        role_params = Hash.new
        role_params[:project_id] = @project.id
        role_params[:employee_id] = developer_id
        role_params[:role] = "developer"
        @role = Role.new(role_params)
        @role.save
      end
    end

    redirect_to project_path(@project)
  end

  def add_testers
    @project = Project.find(params[:id])

    if !params[:tester_ids].nil?
      params[:tester_ids].each do |tester_id|
        role_params = Hash.new
        role_params[:project_id] = @project.id
        role_params[:employee_id] = tester_id
        role_params[:role] = "tester"
        @role = Role.new(role_params)
        @role.save
      end
    end

    redirect_to project_path(@project)
  end


  private
  def project_params
    params.require(:project).permit(:title, :description, {attachments: []}, client_ids:[])
  end

  def find_project_by_url_id
    @project = Project.find(params[:id])
  end

  def get_employees
    @employees = Employee.all
  end

  def add_projectmanager_role
    if params[:project][:employees][:projectmanager_id] != ""
      @role = Role.new(projectmanager_role_params)
      if !@role.save
        render 'new'
      end
    end
  end

  def update_projectmanager_role
    if params[:project][:employees][:projectmanager_id] != ""
      @role = @project.roles.where(:role => "projectmanager").take
      if !@role.update(projectmanager_role_params)
        render 'new'
      end
    end
  end

  def projectmanager_role_params
    @employee = Employee.find(params[:project][:employees][:projectmanager_id])
    role_params = Hash.new
    role_params[:project_id] = @project.id
    role_params[:employee_id] = @employee.id
    role_params[:role] = "projectmanager"
    role_params
  end

end
