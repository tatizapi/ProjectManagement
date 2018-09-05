class CommentsController < ApplicationController
  before_action :get_current_ticket, only: [:index, :new, :create, :edit, :update, :destroy, :delete_attachment]
  before_action :get_current_project, only: [:index]
  before_action :get_first_ticket_comments, only: [:index, :create, :update, :destroy, :delete_attachment]
  before_action :get_all_ticket_comments, only: [:index]
  before_action :get_comment_by_id, only: [:edit, :update, :destroy, :delete_attachment]
  before_action :setup_left_sidebar, only: [:index]

  def index
    @comment = Comment.new
  end

  def new
    @comment = Comment.new
  end

  def create
    @comment = Comment.new(comment_params.merge(user_id: current_user.id, ticket_id: @ticket.id))
    @comment.save
    add_files
  end

  def edit
  end

  def update
    @comment.update(comment_params)
    add_files
    render 'create'
  end

  def destroy
    @comment.destroy
    render 'create'
  end

  def delete_attachment
    attachment = Attachment.find(params[:attachment_id])
    attachment.destroy
    render 'create'
  end

  private

  def comment_params
    params.require(:comment).permit(:body)
  end

  def permit_files
    params.require(:comment).permit({files: []})
  end

  def get_comment_by_id
    @comment = Comment.find(params[:id])
  end

  def get_current_ticket
    @ticket = Ticket.find(params[:ticket_id])
  end

  def get_current_project
    @project = @ticket.project
  end

  def get_first_ticket_comments
    @first_comments = @ticket.comments.order(created_at: :desc).limit(5)
  end

  def get_all_ticket_comments
    @all_ticket_comments = @ticket.comments
  end

  def add_files
    permit_files
    save_files(@comment, params[:comment][:files])
  end
end
