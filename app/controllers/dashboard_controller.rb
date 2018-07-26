class DashboardController < ApplicationController
  def index
    @project = Project.find(params[:project_id])
    @tasks_todo = Task.where(status: 'todo')
    @tasks_inprogress = Task.where(status: 'inprogress')
    @tasks_complete = Task.where(status: 'complete')
    @tasks_done = Task.where(status: 'done')
  end

end
