# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20160413231150) do

  create_table "books", force: :cascade do |t|
    t.string   "image_link_file_name"
    t.string   "image_link_content_type"
    t.integer  "image_link_file_size"
    t.datetime "image_link_updated_at"
    t.string   "title"
    t.string   "authors"
    t.string   "publisher"
    t.date     "published_date"
    t.string   "description"
    t.string   "isbn"
    t.integer  "page_count"
    t.string   "categories"
    t.decimal  "average_rating"
    t.integer  "ratings_count"
    t.string   "preview_link"
    t.string   "info_link"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

end
