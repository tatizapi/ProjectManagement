class Client < User
  has_and_belongs_to_many :projects, join_table: :clients_projects

  #project ---------------------------------------------------
  def can_see_project_roles
    false
  end

  def can_see_projects
    true
  end

  #employee --------------------------------------------------


  #client -----------------------------------------------------
  def can_see_clients
    false
  end

  def can_modify_client
    false
  end

  #others ----------------------------------------------------

end
