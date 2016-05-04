class CreateBooks < ActiveRecord::Migration
  def change
    create_table :books do |t|
      t.string :book_id, unique: true
      t.string :title
      t.string :authors
      t.string :publisher
      t.date :published_date
      t.string :description
      t.string :isbn
      t.integer :page_count
      t.string :categories
      t.decimal :average_rating
      t.integer :ratings_count
      t.string :preview_link
      t.string :info_link
      t.attachment :image_link
      t.timestamps null: false
    end
  end
end
