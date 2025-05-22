class ProjectEntry < ApplicationRecord
  belongs_to :author, class_name: "User"
  belongs_to :assigned, class_name: "User", optional: true
  belongs_to :project
  has_many :actions
  has_many :comments, as: :commentable
  # if changed make sure to fix change_page to prioritize the right order for pagination aaaaaaaalso project entry turbo stream updates
  scope :ordered, -> { order(priority: :desc, id: :asc) }
  validates :priority, numericality: { greater_than_or_equal_to: -2_147_483_648, less_than_or_equal_to: 2_147_483_647, allow_nil: false }
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
  #    def invalid_priority_present
  #      Rails.logger.debug "RAN VALID PRIORITY PRESENT"
  #      Rails.logger.debug priority.present?
  #      if !priority.present?|| (priority.present? && (!priority.is_a?(Integer) || priority < -2_147_483_648 || priority > 2_147_483_647))
  #        Rails.logger.debug "RAN VALID PRIORITY PRESENT 111111"
  #        errors.add(:priority, "must be a valid number between -2,147,483,648 and 2,147,483,647")
  #      end
  #    rescue ArgumentError
  #      Rails.logger.debug "RAN VALID PRIORITY PRESENT 22222"
  #      errors.add(:priority, "is not a valid number")
  #    end
end
