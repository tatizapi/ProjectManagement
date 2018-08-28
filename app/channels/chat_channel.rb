class ChatChannel < ApplicationCable::Channel
  def subscribed
    # Called when the consumer has successfully become a subscriber to this channel.
    stream_from "chat_#{params['project_id']}_channel"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def send_message(data)
    current_user.messages.create!(body: data['message'], project_id: data['project_id'])
    MessageBroadcastJob.perform_later(current_user.messages.last)
  end
end
