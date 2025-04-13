class ProjectEntry < ApplicationRecord
  belongs_to :author, class_name: "User"
  belongs_to :assigned, class_name: "User", optional: true
  belongs_to :project
  has_many :actions
  has_many :comments, as: :commentable

  after_create_commit do
    broadcast_update_to(
      project,
      target: "project_entries_tbody",
      partial: "project_entries/project_entries_table_body",
      locals: { project_entries: project.project_entries }
    )
  end
end
