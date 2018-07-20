class Role < ApplicationRecord
  belongs_to :employee
  belongs_to :project

  validates :employee_id, uniqueness: { scope: :project_id }
  validates :project_id, uniqueness: true
end
