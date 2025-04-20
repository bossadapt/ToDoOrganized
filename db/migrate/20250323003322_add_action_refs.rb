class AddActionRefs < ActiveRecord::Migration[8.0]
  def change
    add_reference :actions, :author, null: false, foreign_key: { to_table: :users }
    add_reference :actions, :project, null: false, foreign_key: true
    add_reference :actions, :project_entry, null: true, foreign_key: true
  end
end
