class UpdateProjectEntryForeignKeyInActions < ActiveRecord::Migration[8.0]
  def change
        # Remove the existing foreign key
        remove_foreign_key :actions, :project_entries

        # Add a new foreign key with ON DELETE SET NULL
        add_foreign_key :actions, :project_entries, on_delete: :nullify
  end
end
