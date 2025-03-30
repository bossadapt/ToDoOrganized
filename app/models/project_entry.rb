class ProjectEntry < ApplicationRecord
  belongs_to :user
  belongs_to :user
  belongs_to :project
  has_many :actions
  has_many :comments, as: :commentable
end
