class AddProjectEntryRefs < ActiveRecord::Migration[8.0]
  def change
    add_reference :project_entries, :project, null: false, foreign_key: true
    add_reference :project_entries, :user, null: false, foreign_key: true
  end
end
