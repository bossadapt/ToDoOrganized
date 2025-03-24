class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :project
  belongs_to :project_entry, optional: true
  belongs_to :action, optional: true
end
