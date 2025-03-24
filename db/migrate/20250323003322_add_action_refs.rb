class AddActionRefs < ActiveRecord::Migration[8.0]
  def change
    add_reference :actions, :user, null: false, foreign_key: true
    add_reference :actions, :project, null: false, foreign_key: true
    add_reference :actions, :project_entry, null: false, foreign_key: true
  end
end
