class DropPosts < ActiveRecord::Migration
  def down
    drop_table :posts
  end
end
