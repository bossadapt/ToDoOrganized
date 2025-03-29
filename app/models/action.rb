class Action < ApplicationRecord
  belongs_to :user
  belongs_to :project
  belongs_to :entry, optional: true
  has_many :comments, as: :commentable
end
