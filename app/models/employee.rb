class Employee < User
  has_many :roles
  has_many :projects, :through => :roles

  has_many :tasks
end
