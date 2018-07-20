class Client < User
  has_and_belongs_to_many :projects, join_table: :clients_projects
end
