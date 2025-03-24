class CreateComments < ActiveRecord::Migration[8.0]
  def change
    create_table :comments do |t|
      t.string :title
      t.string :author_fullname
      t.string :body

      t.timestamps
    end
  end
end
