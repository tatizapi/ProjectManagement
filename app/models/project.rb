class Project < ApplicationRecord
  has_and_belongs_to_many :clients, join_table: :clients_projects
  has_many :roles, dependent: :destroy
  has_many :employees, :through => :roles
  has_many :tickets, dependent: :destroy
  has_many :messages, dependent: :destroy

  has_many :attachments, as: :container, dependent: :destroy

  validates :title, presence: true

  def get_projectmanager
     roles.where(:role => "projectmanager").take.employee
  end

  def get_developers
    developers =  []

    roles.where(:role => "developer").each do |role|
      developers.push(role.employee)
    end

    developers
  end

  def get_testers
    testers = []

    roles.where(:role => "tester").each do |role|
      testers.push(role.employee)
    end

    testers
  end

#reports -----------------------------------------------------------------------
  def get_employee_hash_for_piechart
    hash = tickets.group(:employee_id).count
    hash.transform_keys { |key| Employee.find(key).full_name } #to replace employee_id with the employee's name
  end

  def self.get_employees_from_selected_projects_for_columnchart(container, projects_ids)
    projects_ids.each do |project_id|
      Project.find(project_id).employees.each do |employee|
        unless container.include?(employee)   # to eliminate duplicates
          container.push(employee)
        end
      end
      #@employees_for_columnchart.push(Project.find(project_id).employees) - couldn't do this because Project.find(project_id).employees returns a CollectionProxy object
      #                                                                      which doesn't allow me to acces full_name method on its array objects
    end
  end
end
