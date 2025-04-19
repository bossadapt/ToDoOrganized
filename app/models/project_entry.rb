class ProjectEntry < ApplicationRecord
  belongs_to :author, class_name: "User"
  belongs_to :assigned, class_name: "User", optional: true
  belongs_to :project
  has_many :actions
  has_many :comments, as: :commentable

  after_create_commit do
    broadcast_replace_to(
      project,
      target: "project_entries_tbody",
      partial: "project_entries/project_entries_table_body",
      locals: { project_entries: project.project_entries }
    )
  end
  after_update_commit do
    broadcast_replace_to(
      project,
      target: "project_entries_tbody",
      partial: "project_entries/project_entries_table_body",
      locals: { project_entries: project.project_entries }
    )
    Rails.logger.debug "self:" + self.id.to_s
    Rails.logger.debug "project entry passed? :"
    Rails.logger.debug self.id
    Rails.logger.debug "project entry local? :"
    Rails.logger.debug self.nil?
    broadcast_replace_to(
      project,
      target: "project_entry_update_form",
      partial: "project_entries/project_entry_editable_fields",
      locals: { project_entry: self }
    )
  end
end
