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
    when "todo"
      #started_at is set only once, first time it goes to "inprogress"
      (ticket.started_at.nil?) ? ticket.update(status: "inprogress", started_at: Time.now) : ticket.update(status: "inprogress")
    when "inprogress"
      params[:back] ? status = "todo" : status = "complete"
      (status == "complete") ? ticket.update(status: status, completed_at: Time.now) : ticket.update(status: status)
    when "complete"
      if (params[:back]) && (current_user.is_developer?(@project) || current_user.type == "Admin")
        status = "inprogress"
      elsif (params[:back]) && (current_user.is_tester?(@project))
        status = "todo"
      else
        status = "done"
      end
      (status == "done") ? ticket.update(status: status, ended_at: Time.now) : ticket.update(status: status)
    when "done"
      ticket.update(status: "complete")
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
