class ProjectEntry < ApplicationRecord
  enum :status, [ :new, :assigned, :accepted, :in_progress, :completed ]
  belongs_to :user
  belongs_to :user
  belongs_to :project
  has_many :action
  has_many :comment
end
