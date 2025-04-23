class CreateProjectInvites < ActiveRecord::Migration[8.0]
  def change
    create_table :project_invites do |t|
      t.string :link_code
      t.references :project, null: false, foreign_key: true
      t.datetime :expiration

      t.timestamps
    end
    add_index :project_invites, :link_code, unique: true
  end
end
