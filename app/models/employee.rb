class Employee < User
  has_many :roles
  has_many :projects, :through => :roles

  has_many :tasks


#project ---------------------------------------------------
  def can_see_all_projects
    false
  end

  def can_modify_project
    false
  end

#employee --------------------------------------------------
  def can_see_all_employees
    false
  end

  def can_modify_employee
    false
  end

#client -----------------------------------------------------
  def can_see_all_clients
    false
  end

  def can_modify_client
    false
  end


  def can_see_his_profile
    true
  end

  def can_see_dashboard
    true
  end

  def can_see_project_roles
    true
  end


  def is_projectmanager(project)
    role = Role.find_by(project_id: project.id, employee_id: self.id)
    if role.role == "projectmanager"
      true
    else
      false
    end
  end

end
