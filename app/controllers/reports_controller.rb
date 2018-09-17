class ReportsController < ApplicationController
  before_action :setup_left_sidebar, only: [:show, :new, :create]
  before_action :get_current_project, only: [:show, :new, :create]
  before_action :get_entities_for_dropdowns, only: [:show, :new]

  def show
    @report = Report.find(params[:id])

    set_up_conditions
    tickets_priority_piechart
    tickets_status_piechart
    nr_tickets_per_employee_columnchart
  end

  def new
  end

  def create
    report = Report.new(settings: report_params)
    report.settings['employees'].map!{ |e| Employee.find_by(first_name: e.split()[0], last_name: e.split()[1]).id } if report.settings['employees']
    # ^ because in employees dropdown I only have employees's full names, not employees entities or ids

    if report.save
      redirect_to project_report_path(@project, report)
    else
      render 'new'
    end
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
    params.require(:report).permit(:from_date, :to_date, :projects => [], :employees => [], :tickets => [], :statuses => [])
    # ':array => []' -> syntax has to be like this when working with arrays (and always at the end of the method !)
  end

  def get_current_project
    @project = Project.find(params[:project_id])
  end

  def get_entities_for_dropdowns
    @employees = Employee.all
    @projects = Project.all #although should be only the projects in which the current user is project manager
  end

  def set_up_conditions
    @conditions = { project_id: @report.settings['projects'], employee_id: @report.settings['employees'], type: @report.settings['tickets'], status: @report.settings['statuses'] }
    @conditions[:created_at] = (@report.settings['from_date']..@report.settings['to_date']) unless (@report.settings['from_date'].empty? || @report.settings['to_date'].empty?)
    @conditions.delete_if { |k, v| v.blank? }
  end

  def tickets_priority_piechart
    tickets_by_priority = Ticket.where(@conditions).group(:priority).count
    @nr_of_high_priority_tickets, @nr_of_medium_priority_tickets, @nr_of_low_priority_tickets = tickets_by_priority['high'], tickets_by_priority['medium'], tickets_by_priority['low']
    #puts @nr_of_low_priority_tickets, @nr_of_medium_priority_tickets, @nr_of_high_priority_tickets
  end

  def tickets_status_piechart
    tickets_by_status = Ticket.where(@conditions).group(:status).count
    @nr_of_todo_tickets, @nr_of_inprogress_tickets, @nr_of_complete_tickets, @nr_of_done_tickets = tickets_by_status['To do'], tickets_by_status['In progress'], tickets_by_status['Complete'], tickets_by_status['Done']
  end

  def nr_tickets_per_employee_columnchart
    @employees_for_columnchart = []

    unless @report.settings['employees'].nil?
      @report.settings['employees'].each do |employee_id|
        @employees_for_columnchart.push(Employee.find(employee_id))
      end
    end
    
  end
end
