class Comment < ApplicationRecord
  belongs_to :task
  belongs_to :user

  mount_uploaders :attachments, AttachmentUploader
  serialize :attachments, JSON

  validates :body, presence: true

  def date_time
    created_at.strftime("%d %^b, %H:%M")
  end
end
