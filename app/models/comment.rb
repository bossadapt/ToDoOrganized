class Comment < ApplicationRecord
  belongs_to :author, class_name: "User"
  belongs_to :project
  belongs_to :commentable, polymorphic: true
  after_create_commit -> {
    if commentable.is_a?(ProjectEntry)
      broadcast_prepend_to(
        commentable,
        target: commentable.id.to_s+"_comments",
        partial: "comments/comment",
        locals: { project_entries: project.project_entries }
      )
    end
      broadcast_prepend_to(
        project,
        target: "_comments",
        partial: "comments/comment",
        locals: { project_entries: project.project_entries }
      )
}
  scope :ordered, -> { order(created_at: :desc) }
end
