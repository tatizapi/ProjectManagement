class Task < ApplicationRecord
  has_many :comments
  belongs_to :employee
  belongs_to :project

  mount_uploaders :attachments, AttachmentUploader
  serialize :attachments, JSON

  validates :title, presence: true

  def self.filter_by_status(status)
    where(status: status)
  end

  def self.filter(criteria, current_user_id)
    case criteria
    when "Tasks"
      where(bug: nil)
    when "Bugs"
      where(bug: 1)
    when "Mine"
      where(employee_id: current_user_id)
    when "Created by me"
      where(owner: current_user_id)
    else
      all
    end
  end

  def has_children?
    Task.where(parent_task: id).count != 0
  end

  def get_parent
    Task.find(parent_task)
  end

  def get_children
    Task.where(parent_task: id)
  end

  def get_employee
    Employee.find(employee_id)
  end

  def get_owner
    Employee.find(owner)
  end

  def get_project
    Project.find(project_id)
  end

end
