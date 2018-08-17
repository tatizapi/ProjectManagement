class Message < ApplicationRecord
  belongs_to :user
  belongs_to :project

  validates :body, presence: true

  def get_time
    if created_at.today?
      created_at.strftime("%H:%M")
    elsif created_at == Date.yesterday
      "yesterday"
    else
      created_at.strftime("%d %^b")
    end
  end
end
