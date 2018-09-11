class ReportsController < ApplicationController
  before_action :setup_left_sidebar, only: [:index]
  before_action :get_current_project, only: [:index]

  def index
    @employees = Employee.all
    @projects = Project.all
  end

  def refill_employees_dropdown
    @employees = []
    Role.where(project_id: params[:selected_projects]).each do |role|
      @employees.push(Employee.find(role.employee_id))
    end

    render json: { employees: @employees.map{|e| e.full_name} }
  end

  def tickets_priority
    puts params[:selected_project]
  end

  private

  def get_current_project
    @project = Project.find(params[:project_id])
  end
end
