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
    ticket_start_and_end_date_linechart
    tickets_for_calendar_and_timeline
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

  def ticket_start_and_end_date_linechart
    @tickets_created_at_by_week = Ticket.where(@conditions).group_by{ |t| t.created_at.end_of_week.strftime("%Y-%m-%d") }
    @tickets_ended_at_by_week = Ticket.where(@conditions).reject{ |t| t.ended_at.nil? }.group_by{ |t| t.ended_at.end_of_week.strftime("%Y-%m-%d") }

    @tickets_by_week = {}
    @tickets_created_at_by_week.each do |k, v|
      @tickets_by_week[k] = [v.length]
      @tickets_ended_at_by_week[k] ? @tickets_by_week[k].push(@tickets_ended_at_by_week[k].length) : @tickets_by_week[k].push(0)
    end #@tickets_by_week has: key -> end of week date, value -> [nr_of_created_tickets, nr_of_ended_tickets]
  end

  def tickets_for_calendar_and_timeline
    @tickets = Ticket.where(@conditions)
  end
end
