class Task < ApplicationRecord
  has_many :comments
  belongs_to :employee
  belongs_to :project

  mount_uploaders :attachments, AttachmentUploader
  serialize :attachments, JSON

  validates :title, presence: true
end
