module Admin
  class ProjectsController < ApplicationController
    def index
      @projects = Project.all
    end

    def new
      @project = Project.new
    end

    def create
      @project = Project.new(project_params)
      if @project.save
        redirect_to admin_projects_path
      else
        render 'new'
      end
    end

    def edit
      @project = Project.find(params[:id])
    end

    def update
      @project = Project.find(params[:id])
      if @project.update(project_params)
        redirect_to admin_projects_path
      else
        render 'edit'
      end
    end

    def destroy
      @project = Project.find(params[:id])
      @project.destroy
      redirect_to admin_projects_path
    end

    def assign
      @project = Project.find(params[:id])
      @available_employees = Employee.all - @project.employees
    end

    def make_assign
      @project = Project.find(params[:id])

      if !params[:project][:clients_projects].nil?
        @project.clients = Client.find(params[:project][:clients_projects][:client_id])
      end

      if params[:project][:roles][:employee_id] != ""
        @employee = Employee.find(params[:project][:roles][:employee_id])

        role_params = Hash.new
        role_params[:project_id] = @project.id
        role_params[:employee_id] = @employee.id
        role_params[:role] = "projectmanager"

        role = Role.find_by(project_id: params[:id], role: "projectmanager")
        if role.nil? #role doesn't exist in the database
          @role = Role.new(role_params)
          if @role.save
            redirect_to admin_projects_path
          else
            render 'assign'
          end
        else #project has assigned a project manager
          @role = role
          if @role.update(role_params)
            redirect_to admin_projects_path
          else
            render 'assign'
          end
        end

      else
        redirect_to admin_projects_path
      end

    end


    private
    def project_params
      params.require(:project).permit(:title, :description, {attachments: []})
    end

  end
end
