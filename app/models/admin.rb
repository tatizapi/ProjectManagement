class Admin < User

#project ---------------------------------------------------
  def can_see_projects
    true
  end

  def can_modify_project
    true
  end

  def has_task(project, task)
    true
  end

  def can_modify_task(project, task)
    true
  end

  def can_delete_comment(comment)
    true
  end

#employee --------------------------------------------------
  def can_see_employees
    true
  end

  def can_modify_employee
    true
  end

#client -----------------------------------------------------
  def can_see_clients
    true
  end

  def can_modify_client
    true
  end


  def can_see_his_profile
    false
  end

  def can_see_project_roles
    false
  end

end
