class Posts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.string :review
      
      t.timestamps null: false
    end
  end
end
