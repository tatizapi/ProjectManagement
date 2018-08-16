class Admin < User

#project ---------------------------------------------------
  def can_see_projects?
    true
  end

  def can_modify_project?
    true
  end

#task ------------------------------------------------------
  def can_add_task?(project)
    true
  end

  def can_add_subtask?(task)
    task.status == "todo" || task.status == "inprogress"
  end

  def can_modify_task?(project, task)
    true
  end

  def can_add_bug?(project, task)
    task.status == "complete" && !task.bug
  end

  def can_send_task_back?(project, task)
    task.status != "todo"
  end

  def can_send_task_forward?(project, task)
    task.status != "done"
  end

#comment ---------------------------------------------------
  def can_modify_comment?(comment)
    true
  end

#employee --------------------------------------------------
  def can_see_employees?
    true
  end

  def can_modify_employee?
    true
  end

#client -----------------------------------------------------
  def can_see_clients?
    true
  end

  def can_modify_client?
    true
  end

#others ----------------------------------------------------
  def can_see_his_profile?
    false
  end

  def can_see_project_roles?
    false
  end

  def can_see_chat?(project)
    true
  end
end
