class TicketsController < ApplicationController
  before_action :find_ticket_by_id, only: [:show, :edit, :update, :destroy, :delete_attachment]
  before_action :find_current_project, only: [:new, :create, :show, :edit, :update, :destroy]

  #for developers dropdown
  before_action :get_developers, only: [:new, :create, :edit, :update]

  #index and show are common for admin and employee
  before_action :setup_left_sidebar, only: [:new, :create, :show, :edit, :update]

  def new
    @ticket = Ticket.new(owner: params[:owner], parent_ticket: params[:parent_ticket])
    @is_bug = params[:bug]
    get_ticket_developer #for dropdown when a bug is created
  end

  def create
    puts "bug is #{params[:ticket][:bug]}"
    if (params[:ticket][:bug].empty?)
      @ticket = Task.new(ticket_params.merge(project_id: params[:project_id], status: "todo", created_at: DateTime.current, parent_ticket: params[:ticket][:parent_ticket]))
    else
      @ticket = Bug.new(ticket_params.merge(project_id: params[:project_id], status: "todo", created_at: DateTime.current, parent_ticket: params[:ticket][:parent_ticket]))
    end

    if @ticket.save
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
    if @ticket.update(ticket_params)
      add_files
      redirect_to project_dashboard_index_path(@project)
    else
      render 'edit'
    end
  end

  def destroy
    @ticket.destroy
    redirect_to project_dashboard_index_path(@project)
  end

  def delete_attachment
    attachment = Attachment.find(params[:attachment_id])
    attachment.destroy
    redirect_to edit_project_ticket_path(@ticket.project, @ticket)
  end

  private

  def ticket_params
    params.require(:ticket).permit(:title, :description, :priority, {attachments: []}, :project_id, :developers, :employee_id, :owner)
  end

  def permit_files
    params.require(:ticket).permit({files: []})
  end

  def find_ticket_by_id
    @ticket = Ticket.find(params[:id])
  end

  def find_current_project
    @project = Project.find(params[:project_id])
  end

  def get_developers
    @developers = @project.get_developers - [current_user]
  end

  def get_projects
    @projects = Project.all
  end

  def get_ticket_developer
    if params[:parent_ticket] #only when a subticket is created
      @developer = Employee.find(Ticket.find(params[:parent_ticket]).employee_id)
    end
  end

  def add_files
    permit_files
    save_files(@ticket, params[:ticket][:files])
  end
end
