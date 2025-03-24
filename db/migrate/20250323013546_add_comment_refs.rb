class AddCommentRefs < ActiveRecord::Migration[8.0]
  def change
    add_reference :comments, :project_entry, null: false, foreign_key: true
    add_reference :comments, :user, null: false, foreign_key: true
    add_reference :comments, :action, null: false, foreign_key: true
    add_reference :comments, :project, null: false, foreign_key: true
  end
end
