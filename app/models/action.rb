class Action < ApplicationRecord
  belongs_to :author, class_name: "User"
  belongs_to :project
  belongs_to :project_entry, optional: true
  has_many :comments, as: :commentable
  after_create_commit do
    broadcast_prepend_to(
      project,
      target: "actions_body",
      partial: "actions/action",
      locals: { action: self }
    )
    if !self.project_entry.nil?
      broadcast_prepend_to(
        self.project_entry,
        target: "actions_body",
        partial: "actions/action",
        locals: { action: self }
        )
    end
  end
end
