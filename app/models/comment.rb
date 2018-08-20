class Comment < ApplicationRecord
  belongs_to :ticket
  belongs_to :user

  has_many :attachments, as: :container, dependent: :destroy

  validates :body, presence: true

  def date_time
    created_at.strftime("%d %^b, %H:%M")
  end
end
