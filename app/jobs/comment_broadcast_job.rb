class CommentBroadcastJob < ApplicationJob
  before_perform :wardenize
  queue_as :default

  def perform(comment)
    ActionCable.server.broadcast "comments_#{comment.ticket.id}_channel", comment: render_comment(comment)
  end

  private

  def render_comment(comment)
    @job_renderer.render(partial: 'comments/comment', locals: { comment: comment, modify: false })
  end

  def wardenize
    @job_renderer = ::ApplicationController.renderer.new
    renderer_env = @job_renderer.instance_eval { @env }
    warden = ::Warden::Proxy.new(renderer_env, ::Warden::Manager.new(Rails.application))
    renderer_env['warden'] = warden
  end
end
