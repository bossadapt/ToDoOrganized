class Action < ApplicationRecord
  belongs_to :user
  belongs_to :project
  belongs_to :entry, optional: true
  enum :type, [ :created, :edited, :moved, :deleted ]
end
