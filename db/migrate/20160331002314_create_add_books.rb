class CreateAddBooks < ActiveRecord::Migration
  def change
    create_table :add_books do |t|
      t.attachment :cover
      t.string :title
      t.string :author_first_name
      t.string :author_last_name
      t.boolean :part_of_series
      t.string :series_name
      t.integer :series_number
      t.integer :pages
      t.decimal :rating
      t.string :publisher
      t.time :published_date
      t.integer :isbn10
      t.integer :isbn13
      t.string :genre
      t.string :link
      t.timestamps null: false
    end
  end
end
