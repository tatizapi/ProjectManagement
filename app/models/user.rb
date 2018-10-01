class User < ApplicationRecord
  enum type: { User: 0, Admin: 1, Employee: 2, Client: 3 }

  has_many :comments
  has_many :messages, dependent: :destroy
  has_many :reports, dependent: :destroy

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :rememberable, :trackable#, :registerable, :validatable

  mount_uploader :file, AttachmentUploader

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

#ticket ------------------------------------------------------
  def can_add_ticket?
    false
  end

  def can_add_subticket?(ticket)
    false
  end

  def can_modify_ticket?(project, ticket)
    false
  end

  def can_add_bug?(project, task)
    false
  end

  def can_send_ticket_back?(project, ticket)
    false
  end

  def can_send_ticket_forward?(project, ticket)
    false
  end

  def can_see_ticket_employee?
    true
  end

  def can_see_ticket_details?
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

#chat ------------------------------------------------------
  def can_chat?(project)
    false
  end

  def can_see_chat?(project)
    false
  end

#reports ----------------------------------------------------
  def can_see_reports?(project)
    false
  end

  def get_reports(project_id)
    if type == 'Admin'
      Report.where(project_id: project_id) #admin can see all reports
    elsif type == 'Client'
      reports_result = []

      Report.where(show_to_client: true, project_id: project_id).each do |report|
        reports_result.push(report) if has_projects?(report.settings['projects'])
      end

      reports_result
    else
      reports.where(project_id: project_id)
    end
  end

#others ----------------------------------------------------
  def can_see_his_profile?
    true
  end

  def can_see_dashboard?
    true
  end
end
