class Report < ApplicationRecord
  serialize :settings, JSON

  belongs_to :user
end
