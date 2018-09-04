class CommentsChannel < ApplicationCable::Channel
  def subscribed
    # Called when the consumer has successfully become a subscriber to this channel.
    stream_from "comments_#{params['ticket_id']}_channel"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def send_comment(data)
    current_user.comments.create!(body: data['comment'], ticket_id: data['ticket_id'])
    CommentBroadcastJob.perform_later(current_user.comments.last)
  end
end
