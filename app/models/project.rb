class Project < ApplicationRecord
  has_and_belongs_to_many :clients, join_table: :clients_projects
  has_many :roles
  has_many :employees, :through => :roles
  has_many :tasks

  mount_uploaders :attachments, AttachmentUploader
  serialize :attachments, JSON

  validates :title, presence: true, :on => :create
end
