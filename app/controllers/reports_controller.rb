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
    report = Report.new(title: report_params['title'], user_id: current_user.id, project_id: @project.id, show_to_client: report_params['show_to_client'], save_as_template: report_params['save_as_template'],
                        settings: report_params.except('title', 'show_to_client', 'save_as_template'))
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
    params.require(:report).permit(:from_date, :to_date, :title, :show_to_client, :save_as_template, :projects => [], :employees => [], :tickets => [], :statuses => [])
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
    @tickets_by_priority = Ticket.where(@conditions).group_by(&:priority)
    @tickets_by_priority['low'] = [] if @tickets_by_priority['low'].nil?
    @tickets_by_priority['medium'] = [] if @tickets_by_priority['medium'].nil?
    @tickets_by_priority['high'] = [] if @tickets_by_priority['high'].nil?
  end

  def tickets_status_piechart
    @tickets_by_status = Ticket.where(@conditions).group_by(&:status)
    @tickets_by_status['To do'] = [] if @tickets_by_status['To do'].nil?
    @tickets_by_status['In progress'] = [] if @tickets_by_status['In progress'].nil?
    @tickets_by_status['Complete'] = [] if @tickets_by_status['Complete'].nil?
    @tickets_by_status['Done'] = [] if @tickets_by_status['Done'].nil?
  end

  def nr_tickets_per_employee_columnchart
    @employees_for_columnchart = []

    if !@report.settings['employees'].nil?          #used ' if ! ' instead of 'unless' because 'unless' doesn't support elsif
      Employee.get_selected_employees_for_columnchart(@employees_for_columnchart, @report.settings['employees'])
    elsif !@report.settings['projects'].nil?        #when no employee is selected but some projects are
      Project.get_employees_from_selected_projects_for_columnchart(@employees_for_columnchart, @report.settings['projects'])
    elsif !@report.settings['tickets'].nil? || !@report.settings['statuses'].nil?       #when only tickets or statuses is selected
      Ticket.get_employees_from_selected_tickets_for_columnchart(@employees_for_columnchart, @conditions)
    else
      @employees_for_columnchart = Employee.all     #when nothing is selected
    end
  end

  def ticket_start_and_end_date_linechart
    @tickets_created_at_by_week = Ticket.where(@conditions).group_by{ |t| t.created_at.end_of_week.strftime("%Y-%m-%d") }
    @tickets_ended_at_by_week = Ticket.where(@conditions).reject{ |t| t.ended_at.nil? }.group_by{ |t| t.ended_at.end_of_week.strftime("%Y-%m-%d") }

    @tickets_by_week = {}.merge(@tickets_created_at_by_week).merge(@tickets_ended_at_by_week) #to have all end of weeks from both created_at and ended_at tickets
    @tickets_by_week.keys.sort.each do |week|
      @tickets_created_at_by_week[week] ? @tickets_by_week[week][0] = @tickets_created_at_by_week[week].length : @tickets_by_week[week][0] = 0
      @tickets_ended_at_by_week[week] ? @tickets_by_week[week][1] = @tickets_ended_at_by_week[week].length : @tickets_by_week[week][1] = 0
    end
    #@tickets_by_week has: key -> end of week date, value -> [nr_of_created_tickets, nr_of_ended_tickets]
  end

  def tickets_for_calendar_and_timeline
    @tickets = Ticket.where(@conditions)
  end
end
