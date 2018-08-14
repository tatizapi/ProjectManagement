class ChatController < ApplicationController
  before_action :setup_left_sidebar, only: [:index]
  before_action :get_current_project, only: [:index]

  def index
  end

  def create
  end

  private

  def get_current_project
    @project = Project.find(params[:project_id])
  end
end
