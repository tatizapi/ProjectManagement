class ReportsController < ApplicationController
  before_action :setup_left_sidebar, only: [:show, :new, :create]
  before_action :get_current_project, only: [:show, :new, :create]
  before_action :get_entities_for_dropdowns, only: [:show, :new]

  def show
    @report = Report.find(params[:id])

    tickets_priority_piechart
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
    @projects = Project.all
  end

  def tickets_priority_piechart
    conditions = { project_id: @report.settings['projects'], employee_id: @report.settings['employees'], type: @report.settings['tickets'], status: @report.settings['statuses'] }
    conditions.delete_if { |k, v| v.blank? }
    tickets_by_priority = Ticket.where(conditions).group(:priority).count
    @nr_of_high_priority_tickets = tickets_by_priority['high']
    @nr_of_medium_priority_tickets = tickets_by_priority['medium']
    @nr_of_low_priority_tickets = tickets_by_priority['low']
  end
end
