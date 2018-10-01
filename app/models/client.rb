class Client < User
  has_and_belongs_to_many :projects, join_table: :clients_projects

  #project ---------------------------------------------------
  def can_see_project_roles?
    false
  end

  def can_see_projects?
    true
  end

  def can_see_project_team?
    false
  end

  def can_see_filter?
    false
  end

  #ticket ------------------------------------------------------
  def can_see_ticket_employee?
    false
  end

  def can_see_ticket_details?
    false
  end

  #comment ---------------------------------------------------
  def can_add_and_see_comments?
    false
  end

  #employee --------------------------------------------------

  #client -----------------------------------------------------
  def can_see_clients?
    false
  end

  def can_modify_client?
    false
  end

  #chat ----------------------------------------------------
  def can_see_chat?(project)
    true
  end

  def can_chat?(project)
    true
  end

  #reports ------------------------------------------------
  def can_see_reports?(project)
    true
  end

  def has_projects?(report_projects)
    projects_ids = projects.map{ |project| project.id }
    report_projects_integer = report_projects.map{ |project_id| project_id.to_i }
    (report_projects_integer - projects_ids).empty?
  end
end
