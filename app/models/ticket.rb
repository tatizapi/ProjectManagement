class Ticket < ApplicationRecord
  enum type: { Ticket: 0, Task: 1, Bug: 2 }

  has_many :comments, dependent: :destroy
  belongs_to :employee
  belongs_to :project

  has_many :attachments, as: :container, dependent: :destroy

  validates :title, presence: true

  def self.filter_by_status(status)
    where(status: status)
  end

  def self.filter(criteria, current_user_id)
    case criteria
    when "Tasks"
      Task.all
    when "Bugs"
      Bug.all
    when "Mine"
      where(employee_id: current_user_id)
    when "Created by me"
      where(owner: current_user_id)
    else
      all
    end
  end

  def has_children?
    Task.where(parent_ticket: id).count != 0
  end

  def get_parent
    Ticket.find(parent_ticket)
  end

  def get_children
    Ticket.where(parent_ticket: id)
  end

  def get_employee
    Employee.find(employee_id)
  end

  def get_owner
    User.find(owner)
  end

  def get_project
    Project.find(project_id)
  end

  def get_nr_of_comments
    comments.count
  end
end
