class Employee < User
  has_many :roles
  has_many :projects, :through => :roles
  has_many :tasks

  def is_projectmanager(project)
    role = Role.find_by(project_id: project.id, employee_id: self.id)
    role.role == "projectmanager"
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
    role = Role.find_by(project_id: project.id, employee_id: self.id)

    if role.nil?
      return false
    elsif role.role == "developer"
      return true
    end
  end

  def is_tester(project)
    role = Role.find_by(project_id: project.id, employee_id: self.id)
    
    if role.nil?
      return false
    elsif role.role == "tester"
      return true
    end
  end

end
