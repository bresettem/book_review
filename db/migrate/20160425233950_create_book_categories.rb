class CreateBookCategories < ActiveRecord::Migration
  def change
    create_table :book_categories do |t|
      t.integer :book_id
      t.integer :category
      t.timestamps null: false
    end
  end
end
