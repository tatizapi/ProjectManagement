class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :rememberable, :trackable#, :registerable, :validatable

  scope :clients, -> { where(type: 'Client') }
  scope :employees, -> { where(type: 'Employee') }

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

  def self.types
      %w(Client Employee)
  end

  def full_name
    "#{first_name} #{last_name}"
  end

end
