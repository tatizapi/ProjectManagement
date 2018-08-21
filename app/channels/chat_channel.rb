class ChatChannel < ApplicationCable::Channel
  def subscribed
    stream_from "chat_channel"
  end

  def unsubscribed
  end

  def send_message(data)
    Message.create(body: data['message'])
  end
end
