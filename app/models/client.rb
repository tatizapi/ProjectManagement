class Client < User
  has_and_belongs_to_many :projects

  def full_name
    "#{first_name} #{last_name}"
  end
end
