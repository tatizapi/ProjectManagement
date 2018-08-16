class ChatController < ApplicationController
  before_action :setup_left_sidebar, only: [:index]
  before_action :get_current_project, only: [:index, :create]
  before_action :get_messages, only: [:index, :create]

  def index
    @message = Message.new
  end

  def create
    message = Message.new(message_params.merge(user_id: current_user.id, project_id: params[:project_id]))
    message.save
  end

  private

  def message_params
    params.require(:message).permit(:body)
  end

  def get_messages
    @messages = @project.messages
  end

  def get_current_project
    @project = Project.find(params[:project_id])
  end
end
