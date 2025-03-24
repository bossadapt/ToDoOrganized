class CreateActions < ActiveRecord::Migration[8.0]
  def change
    create_table :actions do |t|
      t.string :user_fullname
      t.integer :type
      t.string :description

      t.timestamps
    end
  end
end
