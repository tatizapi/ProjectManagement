class DashboardController < ApplicationController
  before_action :find_current_project, only: [:index, :change_status]
  before_action :setup_left_sidebar, only: [:index]
  before_action :get_project_tickets, only: [:index, :change_status]

  def index
    #@filter here and in change_status is needed for keeping the filtering when forward and back actions are performed on a ticket
    #not a solution i'm proud of but it works
    @filter = params[:filter]

    respond_to do |format|
       format.js
       format.html
    end
  end

  def change_status
    @filter = params[:filter]
    ticket = Ticket.find(params[:ticket_id])

    case ticket.status
    when "To do"
      #started_at is set only once, first time it goes to "In progress"
      (ticket.started_at.nil?) ? ticket.update(status: "In progress", started_at: Time.now) : ticket.update(status: "In progress")
    when "In progress"
      params[:back] ? status = "To do" : status = "Complete"
      (status == "Complete") ? ticket.update(status: status, completed_at: Time.now) : ticket.update(status: status)
    when "Complete"
      if (params[:back]) && (current_user.is_developer?(@project) || current_user.type == "Admin")
        status = "In progress"
      elsif (params[:back]) && (current_user.is_tester?(@project))
        status = "To do"
      else
        status = "Done"
      end
      (status == "Done") ? ticket.update(status: status, ended_at: Time.now) : ticket.update(status: status)
    when "Done"
      ticket.update(status: "Complete")
    end
  end

  def download
    send_file "#{Rails.root}/public#{params[:attachment].gsub('%2B', '+')}", disposition: 'attachment'
  end

  private

  def find_current_project
    @project = Project.find(params[:project_id])
  end

  def get_project_tickets
    @tickets = @project.tickets.filter(params[:filter], current_user.id)
  end
end
