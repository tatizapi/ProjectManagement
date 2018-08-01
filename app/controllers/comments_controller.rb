class CommentsController < ApplicationController
  before_action :get_current_task, only: [:index, :new, :create]

  def index
    @comments = @task.comments
  end

  def new
    @comment = Comment.new
  end

  def create
    @comment = Comment.new(comment_params.merge(user_id: current_user.id,
                                                task_id: @task.id ))
    @comment.save
    redirect_to project_dashboard_index_path(@task.project_id)
  end

  private

  def comment_params
    params.require(:comment).permit(:body, {attachments: []})
  end

  def get_current_task
    @task = Task.find(params[:task_id])
  end

end
