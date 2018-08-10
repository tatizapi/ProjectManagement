class CommentsController < ApplicationController
  before_action :get_current_task, only: [:index, :new, :create, :destroy]
  before_action :get_task_comments, only: [:index, :create, :destroy]

  def index
  end

  def new
    @comment = Comment.new
  end

  def create
    @comment = Comment.new(comment_params.merge(user_id: current_user.id, task_id: @task.id ))
    @comment.save
  end

  def destroy
    comment = Comment.find(params[:id])
    comment.destroy
  end

  private

  def comment_params
    params.require(:comment).permit(:body, {attachments: []})
  end

  def get_task_comments
    @comments = @task.comments
  end

  def get_current_task
    @task = Task.find(params[:task_id])
  end

end
