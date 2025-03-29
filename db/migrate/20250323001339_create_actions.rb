class CreateActions < ActiveRecord::Migration[8.0]
  def change
    create_table :actions do |t|
      t.string :user_fullname
      t.string :description
      t.string :action_type
      t.timestamps
    end
  end
end
