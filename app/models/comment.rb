class Comment < ApplicationRecord
  belongs_to :author, class_name: "User"
  belongs_to :project
  belongs_to :commentable, polymorphic: true
  after_create_commit -> { broadcast_prepend_to commentable }
  scope :ordered, -> { order(created_at: :desc) }
end
