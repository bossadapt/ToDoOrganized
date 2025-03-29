class AddCommentRefs < ActiveRecord::Migration[8.0]
  def change
    add_reference :comments, :project, null: false, foreign_key: true
    add_reference :comments, :author, null: false, foreign_key: { to_table: :users }
  end
end
