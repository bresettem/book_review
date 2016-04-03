class CreateBooks < ActiveRecord::Migration
  def change
    create_table :books do |t|
      t.string   :title
      t.belongs_to :authors, index: true
      t.boolean  :part_of_series
      t.string   :series_name
      t.integer  :series_number
      t.integer  :pages
      t.decimal  :rating
      t.string   :publisher
      t.time     :published_date
      t.integer  :isbn10
      t.integer  :isbn13
      t.belongs_to :genres, index:true
      t.string   :link
      t.timestamps null: false
    end
  end
end
