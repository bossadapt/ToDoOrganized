class Project < ApplicationRecord
  belongs_to :user
  has_and_belongs_to_many :user
  has_many :action
  has_many :comment
  has_many :project_entries
end
