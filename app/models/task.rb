class Task < ApplicationRecord
  has_many :comments
  belongs_to :employee
  belongs_to :project

  mount_uploaders :attachments, AttachmentUploader
  serialize :attachments, JSON

  validates :title, presence: true

  def find_parent
    puts self
    Task.find(self.parent_id)
  end

end
