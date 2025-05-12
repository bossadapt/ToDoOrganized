class Action < ApplicationRecord
  belongs_to :author, class_name: "User"
  belongs_to :project
  belongs_to :project_entry, optional: true
  has_many :comments, as: :commentable
  scope :ordered, -> { order(created_at: :desc) }
  after_create_commit do
    broadcast_prepend_to(
      self.project,
      target: "actions_body",
      partial: "actions/action",
      locals: { action: self, includeList: [ "Entry ID", "Action Type", "Author", "Description", "Time" ], columnWidthCss: "width:20%;" }
    )
    if !self.project_entry.nil?
      broadcast_prepend_to(
        self.project_entry,
        target: self.project_entry.id.to_s + "actions_body",
        partial: "actions/action",
        locals: { action: self, includeList: [ "Project", "Action Type", "Author", "Description", "Time" ], columnWidthCss: "width:20%;" }
        )
    end
  end
end
