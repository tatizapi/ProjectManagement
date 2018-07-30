class ProjectsController < ApplicationController
  before_action :find_project_by_id, only: [:show, :edit, :update, :destroy]
  before_action :get_projects, only: [:new, :create, :edit, :update]

  #for project manager dropdown
  before_action :get_employees, only: [:new, :create, :edit, :update]

  #for clients check boxes
  before_action :get_clients, only: [:new, :create, :edit, :update]

  #index and show are common for admin and employee
  before_action :setup_left_sidebar, only: [:index, :show]


  def index
  end

  def show
    @projectmanager = @project.get_projectmanager
    @developers = @project.get_developers
    @testers = @project.get_testers
  end

  def new
    @project = Project.new
  end

  def create
    @project = Project.new(project_params)

    if @project.save
      add_projectmanager_role
      redirect_to project_path(@project)
    else
      render 'new'
    end
  end

  def edit
    #to have a selected employee on dropdown
    @projectmanager = @project.get_projectmanager
  end

  def update
    if @project.update(project_params)
      update_projectmanager_role
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

    #get_employees_filtered_by_role
    @projects = Project.all
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

#-------------------------------------------------------------------------------
  private
  def project_params
    params.require(:project).permit(:title, :description, {attachments: []}, client_ids:[])
  end

  def find_project_by_id
    @project = Project.find(params[:id])
  end

  def get_employees
    @employees = Employee.all
  end

  def get_projects
    @projects = Project.all
  end

  def get_clients
    @clients = Client.all
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

  def add_projectmanager_role
    @role = Role.new(projectmanager_role_params)
    @role.save
  end

  def update_projectmanager_role
    @role = @project.roles.where(:role => "projectmanager").take
    @role.update(projectmanager_role_params)
  end

  def projectmanager_role_params
    @employee = Employee.find(params[:project][:employee_id])
    role_params = { "project_id": @project.id, "employee_id": @employee.id, "role": "projectmanager" }
  end

end
