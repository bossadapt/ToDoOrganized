class Project < ApplicationRecord
  belongs_to :owner, class_name: "User"
  has_and_belongs_to_many :users
  has_many :actions
  has_many :comments
  has_many :project_entries
end
