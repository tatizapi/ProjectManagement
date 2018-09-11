class ReportsController < ApplicationController
  before_action :setup_left_sidebar, only: [:index, :create]
  before_action :get_current_project, only: [:index, :create]

  def index
    @employees = Employee.all
    @projects = Project.all

    @tickets_priority_piechart = {"high"=>2, "low"=>4, "medium"=>7}
    @nr_of_high_priority_tickets = 3
    @nr_of_medium_priority_tickets = 4
    @nr_of_low_priority_tickets = 2
  end

  def create
    @employees = Employee.all
    @projects = Project.all

    @tickets_priority_piechart = Ticket.where(project_id: params[:select_on_projects]).group(:priority).count
    @nr_of_high_priority_tickets = 3
    @nr_of_medium_priority_tickets = 4
    @nr_of_low_priority_tickets = 2
    render 'index'
  end

  def refill_employees_dropdown
    @employees = []
    Role.where(project_id: params[:selected_projects]).each do |role|
      @employees.push(Employee.find(role.employee_id))
    end

    render json: { employees: @employees.map{|e| e.full_name} }
  end

  private

  def report_params
    params.permit(:select_on_projects, :select_on_employees)
  end

  def get_current_project
    @project = Project.find(params[:project_id])
  end
end
