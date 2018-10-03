class Report < ApplicationRecord
  serialize :settings, JSON

  belongs_to :user
  belongs_to :project

  #validates_presence_of :title, :if => :save_as_template?
  def from_ids_to_full_names
    full_names = []

    unless settings['employees'].nil?
      settings['employees'].each do |employee_id|
        full_names.push(Employee.find(employee_id).full_name)
      end
    end

    full_names
  end
end
