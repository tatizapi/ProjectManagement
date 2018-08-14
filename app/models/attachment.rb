class Attachment < ApplicationRecord
  belongs_to :container, polymorphic: true

  mount_uploader :file, AttachmentUploader
end
