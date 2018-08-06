class Employee < User
  has_many :roles
  has_many :projects, :through => :roles
  has_many :tasks

  def is_projectmanager(project)
    role = get_role(project)
    role.role == "projectmanager"
  end

  def can_modify_task(project, task)
    is_projectmanager(project) ||
    (task.owner && task.owner == self.id)
  end

  def can_delete_comment(comment)
    self.id == comment.user_id
  end

  def self.get_employees_filtered_by_role(employee_id)
    projects_projectmanager_role = []
    projects_developer_role = []
    projects_tester_role = []

    Employee.find(employee_id).roles.where(:role => "projectmanager").each do |role|
      projects_projectmanager_role.push(role.project)
    end

    Employee.find(employee_id).roles.where(:role => "developer").each do |role|
      projects_developer_role.push(role.project)
    end

    Employee.find(employee_id).roles.where(:role => "tester").each do |role|
      projects_tester_role.push(role.project)
    end

    return projects_projectmanager_role, projects_developer_role, projects_tester_role
  end

  def is_developer(project)
    role = get_role(project)

    if role.nil?
      return false
    elsif role.role == "developer"
      return true
    end
  end

  def is_tester(project)
    role = get_role(project)

    if role.nil?
      return false
    elsif role.role == "tester"
      return true
    end
  end

  def get_role(project)
    Role.find_by(project_id: project.id, employee_id: self.id)
  end

  def has_task(project, task)
    role = get_role(project)

    if self.id == task.employee_id && role.role == "developer" &&
       (task.status == "todo" || task.status == "inprogress")
      return true
    elsif role.role == "tester" && task.status == "complete"
      return true
    end
  end

end
