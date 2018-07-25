class Task < ApplicationRecord
  belongs_to :employee
  belongs_to :project

  validates :title, presence: true, :on => :create
  validates :employee, presence: true, :on => :create
end
