class Task < ApplicationRecord
  has_many :comments
  belongs_to :employee
  belongs_to :project

  mount_uploaders :attachments, AttachmentUploader
  serialize :attachments, JSON

  validates :title, presence: true

  def find_parent
    Task.find(self.parent_task)
  end

  def self.filter_by_status(status)
    where(status: status)
  end

  def self.filter(criteria, current_user_id)
    case criteria
    when "Only tasks"
      where(bug: nil)
    when "Only bugs"
      where(bug: 1)
    when "Only mine"
      where(employee_id: current_user_id)
    when "Only created by me"
      where(owner: current_user_id)
    else
      all
    end
  end

  def get_employee
    Employee.find(self.employee_id)
  end

end
