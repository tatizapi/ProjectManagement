class Message < ApplicationRecord
  belongs_to :user
  belongs_to :project

  validates :body, presence: true

  after_create_commit :broadcast_message

  def get_time
    if created_at.today?
      created_at.strftime("%H:%M")
    elsif created_at.to_date == Date.yesterday
      "yesterday"
    else
      created_at.strftime("%d %^b")
    end
  end

  private

  def broadcast_message
    MessageBroadcastJob.perform_later(self)
  end
end
