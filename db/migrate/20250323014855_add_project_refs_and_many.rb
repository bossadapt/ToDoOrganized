class AddProjectRefs < ActiveRecord::Migration[8.0]
  def change
    # for owner
    add_reference :projects, :user, null: false, foreign_key: true
  end
end
