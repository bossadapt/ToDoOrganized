class CreateProjectEntries < ActiveRecord::Migration[8.0]
  def change
    create_table :project_entries do |t|
      t.string :creator_fullname
      t.string :assigned_fullname
      t.string :title
      t.integer :priority
      t.string :description
      t.integer :status

      t.timestamps
    end
  end
end
