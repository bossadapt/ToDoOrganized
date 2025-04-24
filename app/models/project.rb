class Project < ApplicationRecord
  belongs_to :owner, class_name: "User", foreign_key: "owner_id"
  has_and_belongs_to_many :users
  has_many :actions
  has_many :comments
  has_many :project_entries
  has_many :project_invites
  def to_description
    "Project[Title: #{self.title} | Description: #{self.description}]"
  end
end
