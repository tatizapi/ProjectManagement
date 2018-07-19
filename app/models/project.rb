class Project < ApplicationRecord
  has_many :clients

  mount_uploaders :attachments, AttachmentUploader
  serialize :attachments, JSON

  validates :title, presence: true, :on => :create
end
