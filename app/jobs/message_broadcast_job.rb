class MessageBroadcastJob < ApplicationJob
  before_perform :wardenize
  queue_as :default

  def perform(message)
    ActionCable.server.broadcast "chat_#{message.project.id}_channel", message: render_message(message)
  end

  private

  def render_message(message)
    @job_renderer.render(partial: 'messages/message', locals: { message: message })
  end

  def wardenize
    @job_renderer = ::ApplicationController.renderer.new
    renderer_env = @job_renderer.instance_eval { @env }
    warden = ::Warden::Proxy.new(renderer_env, ::Warden::Manager.new(Rails.application))
    renderer_env['warden'] = warden
  end
end
