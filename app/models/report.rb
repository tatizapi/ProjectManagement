class Report < ApplicationRecord
  serialize :settings, JSON

  belongs_to :user
  belongs_to :project

  #validates_presence_of :title, :if => :save_as_template?
end
