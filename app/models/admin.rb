class Admin < User

#project ---------------------------------------------------
  def can_see_projects?
    true
  end

  def can_modify_project?
    true
  end

#ticket ------------------------------------------------------
  def can_add_ticket?(project)
    true
  end

  def can_add_subticket?(ticket)
    ticket.status == "todo" || ticket.status == "inprogress"
  end

  def can_modify_ticket?(project, ticket)
    true
  end

  def can_add_bug?(project, task)
    task.status == "complete" && !(task.type == 2)
  end

  def can_send_ticket_back?(project, ticket)
    ticket.status != "todo"
  end

  def can_send_ticket_forward?(project, ticket)
    ticket.status != "done"
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
