class User < ApplicationRecord
  enum type: { User: 0, Admin: 1, Employee: 2, Client: 3}

  has_many :comments

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :rememberable, :trackable#, :registerable, :validatable

  mount_uploader :attachment, AttachmentUploader

  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :password, presence: true, length: { minimum: 6 }, :on => :create
  validates :username, presence: true, uniqueness: true, length: { minimum: 3 }
  validates :email, uniqueness: true
  validates_format_of :email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i

  def email_required?
    false
  end

  def will_save_change_to_email?
    false
  end

  def full_name
    "#{first_name} #{last_name}"
  end

#project ---------------------------------------------------
  def can_see_projects?
    false
  end

  def can_modify_project?
    false
  end

  def can_see_project_team?
    true
  end

  def can_see_project_roles?
    true
  end

  def can_see_filter?
    true
  end

#task ------------------------------------------------------
  def can_add_task?
    false
  end

  def can_add_subtask?(task)
    false
  end

  def can_modify_task?(project, task)
    false
  end

  def can_add_bug?(project, task)
    false
  end

  def can_send_task_back?(project, task)
    false
  end

  def can_send_task_forward?(project, task)
    false
  end

  def can_see_task_employee?
    true
  end

  def can_see_task_details?
    true
  end

#comment ---------------------------------------------------
  def can_add_and_see_comments?
    true
  end

  def can_modify_comment?(comment)
    false
  end

#employee --------------------------------------------------
  def can_see_employees?
    false
  end

  def can_modify_employee?
    false
  end

  def is_projectmanager?(project)
    false
  end

  def is_tester?(project)
    false
  end

  def is_developer?(project)
    false
  end

#client -----------------------------------------------------
  def can_see_clients?
    false
  end

  def can_modify_client?
    false
  end

#others ----------------------------------------------------
  def can_see_his_profile?
    true
  end

  def can_see_dashboard?
    true
  end

end
