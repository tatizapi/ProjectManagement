class Client < User
  self.inheritance_column = :_type_disabled
end
