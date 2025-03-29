class ProjectEntry < ApplicationRecord
  enum :status, [ :new, :assigned, :accepted, :in_progress, :completed ]
  belongs_to :user
  belongs_to :user
  belongs_to :project
  has_many :actions
  has_many :comments, as: :commentable
end
