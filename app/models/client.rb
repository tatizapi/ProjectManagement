class Client < User
  #self.inheritance_column = :_type_disabled

  has_many :users, as: :user_test

  #attr_accessible :username, :email, :password
end
