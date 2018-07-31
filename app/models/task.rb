class Task < ApplicationRecord
  belongs_to :employee
  belongs_to :project

  mount_uploaders :attachments, AttachmentUploader
  serialize :attachments, JSON

  validates :title, presence: true, :on => :create
end
