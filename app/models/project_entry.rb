class ProjectEntry < ApplicationRecord
  belongs_to :author, class_name: "User"
  belongs_to :assigned, class_name: "User", optional: true
  belongs_to :project
  after_create_commit -> { broadcast_prepend_to project }
  has_many :actions
  has_many :comments, as: :commentable
end
