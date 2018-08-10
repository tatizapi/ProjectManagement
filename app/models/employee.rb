class Employee < User
  has_many :roles
  has_many :projects, :through => :roles
  has_many :tasks

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

#task --------------------------------------------------------------------------
  def can_add_task?(project)
    is_projectmanager?(project)
  end

  def can_add_subtask?(task)
    (task.employee_id == id) && (task.status != "complete") && (task.status != "done")
  end

  def can_modify_task?(project, task)
    (task.status != "done") && (is_projectmanager?(project) || (task.owner && task.owner == id))
  end

  def can_add_bug?(project, task)
    (is_tester?(project)) && (task.status == "complete") && (!task.bug)
  end

  def can_send_task_back?(project, task)
    (is_developer?(project) && has_task?(task) && (task.status == "inprogress" || task.status == "complete")) || (is_tester?(project) && (task.status == "complete" || task.status == "done"))
  end

  def can_send_task_forward?(project, task)
    (is_developer?(project) && has_task?(task) && (task.status == "todo" || task.status == "inprogress")) || (is_tester?(project) && task.status == "complete")
  end

  def has_task?(task)
    task.employee_id == id
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

end
