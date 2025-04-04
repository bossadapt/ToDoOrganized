class Comment < ApplicationRecord
  belongs_to :author, class_name: "User"
  belongs_to :project
  belongs_to :commentable, polymorphic: true
  scope :ordered, -> { order(created_at: :desc) }
end
