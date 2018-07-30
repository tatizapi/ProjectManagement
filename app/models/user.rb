class User < ApplicationRecord
  enum type: { User: 0, Admin: 1, Employee: 2, Client: 3}

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :rememberable, :trackable#, :registerable, :validatable

  mount_uploader :attachment, AttachmentUploader

  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :password, presence: true, length: { minimum: 6 }, :on => :create
  validates :username, presence: true, length: { minimum: 3 }
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
  def can_see_all_projects
    false
  end

  def can_modify_project
    false
  end

  def can_see_project_roles
    true
  end
  
#employee --------------------------------------------------
  def can_see_all_employees
    false
  end

  def can_modify_employee
    false
  end

  def is_projectmanager(project)
    false
  end

#client -----------------------------------------------------
  def can_see_all_clients
    false
  end

  def can_modify_client
    false
  end

#others ----------------------------------------------------
  def can_see_his_profile
    true
  end

  def can_see_dashboard
    true
  end

end
