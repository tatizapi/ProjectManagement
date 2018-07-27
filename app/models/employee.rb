class Employee < User
  has_many :roles
  has_many :projects, :through => :roles
  has_many :tasks

  def can_add_tasks(project)
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

end
