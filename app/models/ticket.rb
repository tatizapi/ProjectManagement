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
    project
  end

  def get_nr_of_comments
    comments.count
  end

  def format_deadline
    deadline.strftime("%Y-%m-%d %I:%M")
  end

#time_tracking tab -------------------------------------------------------------
  def format_date(date)
    date.strftime("%d/%m/%Y %H:%M")
  end

  def remaining_time(deadline)
    remaining_time = (deadline - Time.now).to_i #difference between two dates is in seconds

    if remaining_time > 0
      nr_of_days = remaining_time / 86400
      nr_of_hours = (remaining_time % 86400) / 3600
      nr_of_minutes = ((remaining_time % 86400) % 3600) / 60
      "#{nr_of_days} days, #{nr_of_hours} hours, #{nr_of_minutes} minutes"
    else
      "you're done"
    end
  end

  def passed_time_percent(deadline)
    total_time = (deadline - created_at).to_i
    passed_time = (Time.now - created_at).to_i
    percent = (passed_time.to_f / total_time) * 100

    if percent < 100
      sprintf('%.2f', percent)
    else
      "100"
    end
  end

  def worked_on_time
    nr_of_days = (started_at.to_datetime..ended_at.to_datetime).count {|date| (1..5).include?(date.wday) }

    if nr_of_days > 1
      "Aprox. #{nr_of_days} days"
    elsif nr_of_days > 0
      nr_of_hours = ((ended_at - started_at).to_i) / 3600
      "Aprox. #{nr_of_hours} hours"
    end
  end
end
