class Employee < User
  has_many :roles
  has_many :projects, :through => :roles
  has_many :tickets

  def is_projectmanager?(project)
    get_role(project).role == "projectmanager"
  end

  def is_developer?(project)
    unless get_role(project).nil? #can be nil actually, see developers, at checkbox
      get_role(project).role == "developer"
    end
  end

  def is_tester?(project)
    unless get_role(project).nil? #can be nil actually, see testers, at checkbox
      get_role(project).role == "tester"
    end
  end

#ticket --------------------------------------------------------------------------
  def can_add_ticket?(project)
    is_projectmanager?(project)
  end

  def can_add_subticket?(ticket)
    (ticket.employee_id == id) && (ticket.status != "complete") && (ticket.status != "done")
  end

  def can_modify_ticket?(project, ticket)
    (ticket.status != "done") && (is_projectmanager?(project) || (ticket.owner && ticket.owner == id))
  end

  def can_add_bug?(project, task)
    (is_tester?(project)) && (task.status == "complete") && (task.type != "Bug")
  end

  def can_send_ticket_back?(project, ticket)
    (is_developer?(project) && has_ticket?(ticket) && (ticket.status == "inprogress" || ticket.status == "complete")) || (is_tester?(project) && (ticket.status == "complete" || ticket.status == "done"))
  end

  def can_send_ticket_forward?(project, ticket)
    (is_developer?(project) && has_ticket?(ticket) && (ticket.status == "todo" || ticket.status == "inprogress")) || (is_tester?(project) && ticket.status == "complete")
  end

  def has_ticket?(ticket)
    ticket.employee_id == id
  end

  def can_modify_comment?(comment)
    id == comment.user_id
  end

#others ------------------------------------------------------------------------
  def self.get_employees_filtered_by_role(employee_id)
    projects_projectmanager_role = []
    projects_developer_role = []
    projects_tester_role = []

    Employee.find(employee_id).roles.each do |role|
      case role.role
      when "projectmanager"
        projects_projectmanager_role.push(role.project)
      when "developer"
        projects_developer_role.push(role.project)
      when "tester"
        projects_tester_role.push(role.project)
      end
    end

    return projects_projectmanager_role, projects_developer_role, projects_tester_role
  end

  def get_role(project)
    Role.find_by(project_id: project.id, employee_id: id)
  end

  def can_see_chat?(project)
    is_projectmanager?(project)
  end

  def can_chat?(project)
    is_projectmanager?(project)
  end
end
