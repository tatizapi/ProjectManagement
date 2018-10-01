class Report < ApplicationRecord
  serialize :settings, JSON

  belongs_to :user
  belongs_to :project
end
