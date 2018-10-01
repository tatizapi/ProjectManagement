class ReportsController < ApplicationController
  before_action :setup_left_sidebar, only: [:index, :show, :new, :create]
  before_action :find_report_by_id, only: [:show, :destroy]
  before_action :get_current_project, only: [:index, :show, :new, :create]
  before_action :get_entities_for_dropdowns, only: [:show, :new]

  def index
    @reports = current_user.get_reports(@project.id).paginate(:page => params[:page], :per_page => 15)
  end

  def show
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
    report = Report.new(title: report_params['title'], show_to_client: report_params['show_to_client'], user_id: current_user.id, project_id: @project.id, settings: report_params.except('title', 'show_to_client'))
    report.settings['employees'].map!{ |e| Employee.find_by(first_name: e.split()[0], last_name: e.split()[1]).id } if report.settings['employees']
    # ^ because in employees dropdown I only have employees's full names, not employees entities or ids
    report.settings.merge!(projects: [@project.id.to_s]) if current_user.is_projectmanager?(@project)
    # ^ when project manager creates a report, settings['projects'] must include report's project 

    if report.save
      redirect_to project_report_path(@project, report)
    else
      render 'new'
    end
  end

  def destroy
    @report.destroy
    redirect_to project_reports_path
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
    params.require(:report).permit(:from_date, :to_date, :title, :show_to_client, :projects => [], :employees => [], :tickets => [], :statuses => [])
    # ':array => []' -> syntax has to be like this when working with arrays (and always at the end of the method !)
  end

  def find_report_by_id
    @report = Report.find(params[:id])
  end

  def get_current_project
    @project = Project.find(params[:project_id])
  end

  def get_entities_for_dropdowns
    if current_user.is_projectmanager?(@project)
      @employees = @project.employees - [current_user]
    else
      @projects = Project.all
      @employees = Employee.all
    end
  end

  def set_up_conditions
    @conditions = { project_id: @report.settings['projects'], employee_id: @report.settings['employees'], type: @report.settings['tickets'], status: @report.settings['statuses'] }
    @conditions[:created_at] = (@report.settings['from_date']..@report.settings['to_date']) unless (@report.settings['from_date'].empty? || @report.settings['to_date'].empty?)
    @conditions.delete_if { |k, v| v.blank? }
  end

  def tickets_priority_piechart
    tickets_by_priority = Ticket.where(@conditions).group(:priority).count
    tickets_by_priority['high'].nil? ? @nr_of_high_priority_tickets = 0 : @nr_of_high_priority_tickets = tickets_by_priority['high']
    tickets_by_priority['medium'].nil? ? @nr_of_medium_priority_tickets = 0 : @nr_of_medium_priority_tickets = tickets_by_priority['medium']
    tickets_by_priority['low'].nil? ? @nr_of_low_priority_tickets = 0 : @nr_of_low_priority_tickets = tickets_by_priority['low']
    return @nr_of_high_priority_tickets, @nr_of_medium_priority_tickets, @nr_of_low_priority_tickets
  end

  def tickets_status_piechart
    tickets_by_status = Ticket.where(@conditions).group(:status).count
    tickets_by_status['To do'].nil? ? @nr_of_todo_tickets = 0 : @nr_of_todo_tickets = tickets_by_status['To do']
    tickets_by_status['In progress'].nil? ? @nr_of_inprogress_tickets = 0 : @nr_of_inprogress_tickets = tickets_by_status['In progress']
    tickets_by_status['Complete'].nil? ? @nr_of_complete_tickets = 0 : @nr_of_complete_tickets = tickets_by_status['Complete']
    tickets_by_status['Done'].nil? ? @nr_of_done_tickets = 0 : @nr_of_done_tickets = tickets_by_status['Done']
    return @nr_of_todo_tickets, @nr_of_inprogress_tickets, @nr_of_complete_tickets, @nr_of_done_tickets
  end

  def nr_tickets_per_employee_columnchart
    @employees_for_columnchart = []

    if !@report.settings['employees'].nil?                                         #used ' if ! ' instead of 'unless' because 'unless' doesn't support elsif
      Employee.get_selected_employees_for_columnchart(@employees_for_columnchart, @report.settings['employees'])
    elsif !@report.settings['projects'].nil?                                       #when no employee is selected but some projects are
      Project.get_employees_from_selected_projects_for_columnchart(@employees_for_columnchart, @report.settings['projects'])
    elsif !@report.settings['tickets'].nil? || !@report.settings['statuses'].nil?  #when only tickets or statuses is selected
      Ticket.get_employees_from_selected_tickets_for_columnchart(@employees_for_columnchart, @conditions)
    else
      @employees_for_columnchart = Employee.all
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
