class AddMany2Many < ActiveRecord::Migration[8.0]
    def change
      # for owner

      create_table :project_users, id: false do |t|
        # creates foreign keys linking the join table to the `project` and `users` tables
        t.belongs_to :user
        t.belongs_to :project
      end
    end
end
