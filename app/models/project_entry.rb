class ProjectEntry < ApplicationRecord
  belongs_to :author, class_name: "User"
  belongs_to :assigned, class_name: "User", optional: true
  belongs_to :project
  has_many :actions
  has_many :comments, as: :commentable
  validates :priority, numericality: { greater_than_or_equal_to: -2_147_483_648, less_than_or_equal_to: 2_147_483_647 }
  scope :ordered, -> { order(priority: :desc, created_at: :asc) }

  after_create_commit do
    broadcast_replace_to(
      project,
      target: "project_entries_tbody",
      partial: "project_entries/project_entries_table_body",
      locals: { project_entries: project.project_entries }
    )
  end
  after_destroy_commit do
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
    broadcast_replace_to(
      self,
      target: "project_entry_update_form",
      partial: "project_entries/project_entry_editable_fields",
      locals: { project_entry: self }
    )
  end
  def to_description
    "Project Entry:[\nTitle: #{self.title} \nAssigned: #{self.assigned} \nDescription: #{self.description} \nPriority: #{self.priority}\n]"
  end
end
