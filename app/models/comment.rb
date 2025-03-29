class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :project
  belongs_to :commentable, polymorphic: true
end
