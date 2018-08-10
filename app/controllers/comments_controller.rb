class CommentsController < ApplicationController
  before_action :get_current_task, only: [:index, :new, :create, :edit, :update, :destroy]
  before_action :get_task_comments, only: [:index, :create, :update, :destroy]
  before_action :get_comment_by_id, only: [:edit, :update, :destroy]

  def index
  end

  def new
    @comment = Comment.new
  end

  def create
    @comment = Comment.new(comment_params.merge(user_id: current_user.id, task_id: @task.id))
    @comment.save
  end

  def edit
  end

  def update
    @comment.update(comment_params)
    render 'create'
  end

  def destroy
    @comment.destroy
    render 'create'
  end

  private

  def comment_params
    params.require(:comment).permit(:body, {attachments: []})
  end

  def get_comment_by_id
    @comment = Comment.find(params[:id])
  end

  def get_current_task
    @task = Task.find(params[:task_id])
  end

  def get_task_comments
    @comments = @task.comments
  end
end
