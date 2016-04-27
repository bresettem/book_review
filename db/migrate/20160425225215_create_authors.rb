class CreateAuthors < ActiveRecord::Migration
  def change
    create_table :authors do |t|
      t.string :authors
      t.string :bio
      t.attachment :image_link
      t.timestamps null: false
    end
  end
end
