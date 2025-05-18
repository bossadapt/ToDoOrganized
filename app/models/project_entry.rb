class ProjectEntry < ApplicationRecord
  belongs_to :author, class_name: "User"
  belongs_to :assigned, class_name: "User", optional: true
  belongs_to :project
  has_many :actions
  has_many :comments, as: :commentable
  validates :priority, numericality: { greater_than_or_equal_to: -2_147_483_648, less_than_or_equal_to: 2_147_483_647 }
  # if changed make sure to fix change_page to prioritize the right order for pagination aaaaaaaalso project entry turbo stream updates
  scope :ordered, -> { order(priority: :desc, id: :asc) }
  scope :rev_ordered, -> { order(priority: :asc, id: :desc) }

  after_create_commit do
    # update either assigned or new based on status
    broadcast_replace_to(
      project,
      target: "project_entries_column_body_"+status,
      partial: "project_entries/project_entries_column_body",
      locals: { project: self.project, status: self.status }
    )
  end
  after_destroy_commit do
    broadcast_replace_to(
      project,
      target: "project_entries_column_body_"+status,
      partial: "project_entries/project_entries_column_body",
      locals: { project: self.project, status: self.status }
    )
  end
  after_update_commit do
    # TODO: make it so that editing assigned moves it to assigned
    # TODO: if update does not include move then just update the

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
