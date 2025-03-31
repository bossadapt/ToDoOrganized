class AddProjectEntryRefs < ActiveRecord::Migration[8.0]
  def change
    add_reference :project_entries, :project, null: false, foreign_key: true
    add_reference :project_entries, :author, null: false, foreign_key: { to_table: :users }
    add_reference :project_entries, :assigned, null: true, foreign_key: { to_table: :users }
  end
end
