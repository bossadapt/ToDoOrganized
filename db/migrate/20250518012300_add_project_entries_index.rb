class AddProjectEntriesIndex < ActiveRecord::Migration[8.0]
  def change
    # this helps populate columns and also assist in paginating it
    add_index :project_entries, [ :project_id, :status, :priority, :id ]
  end
end
