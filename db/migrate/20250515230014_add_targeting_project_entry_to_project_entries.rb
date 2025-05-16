class AddTargetingProjectEntryToProjectEntries < ActiveRecord::Migration[8.0]
  def change
    add_column :actions, :targeting_project_entry, :boolean
  end
end
