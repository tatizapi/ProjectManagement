class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :rememberable, :trackable#, :validatable

  scope :clients, -> { where(type: 'Client') }

  validates :first_name, :last_name, :password, :username, presence: true
  validates :password, length: { minimum: 6 }
  validates :username, length: { minimum: 3 }
  validates_format_of :email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i

  def email_required?
    false
  end

  def will_save_change_to_email?
    false
  end

  def self.types
      %w(Client)
  end

end
