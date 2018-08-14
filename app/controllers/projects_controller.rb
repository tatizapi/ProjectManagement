class ProjectsController < ApplicationController
  before_action :find_project_by_id, only: [:show, :edit, :update, :destroy, :developers, :testers, :manage_developers, :manage_testers]

  #for project manager dropdown
  before_action :get_employees, only: [:new, :create, :edit, :update, :developers, :testers]

  #for clients check boxes
  before_action :get_clients, only: [:new, :create, :edit, :update]

  #index and show are common for admin and employee
  before_action :setup_left_sidebar, only: [:index, :show, :new, :create, :edit, :update, :developers, :testers]


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
      add_files
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
      add_files
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

  def delete_attachment
    attachment = Attachment.find(params[:attachment_id])
    attachment.destroy
    redirect_to edit_project_path(Project.find(attachment.container_id))
  end

  def developers
    #refactor
    @available_employees = Employee.all - @project.get_testers.push(@project.get_projectmanager)
  end

  def testers
    #refactor
    @available_employees = Employee.all - @project.get_developers - [@project.get_projectmanager]
  end

  def manage_developers
    destroy_existing_developers

    #can be better?
    unless params[:developer_ids].nil?
      params[:developer_ids].each do |developer_id|
        @role = Role.new(developer_role_params(developer_id))
        @role.save
      end
    end

    redirect_to project_path(@project)
  end

  def manage_testers
    destroy_existing_testers

    #can be better?
    unless params[:tester_ids].nil?
      params[:tester_ids].each do |tester_id|
        @role = Role.new(tester_role_params(tester_id))
        @role.save
      end
    end

    redirect_to project_path(@project)
  end

#-------------------------------------------------------------------------------
  private
  def project_params
    params.require(:project).permit(:title, :description, client_ids:[])
  end

  def permit_files
    params.require(:project).permit({files: []})
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

  def add_files
    permit_files
    save_files(@project, params[:project][:files])
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

  def destroy_existing_developers
    @project.roles.each do |role|
      if role.role == "developer" #is_developer? pe role model (de ce ar fi mai util asa tho?)
        role.destroy
      end
    end
  end

  def destroy_existing_testers
    @project.roles.each do |role|
      if role.role == "tester"
        role.destroy
      end
    end
  end

  def developer_role_params(developer_id)
    role_params = { "project_id": @project.id, "employee_id": developer_id, "role": "developer" }
  end

  def tester_role_params(developer_id)
    role_params = { "project_id": @project.id, "employee_id": developer_id, "role": "tester" }
  end

end
