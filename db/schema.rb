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

ActiveRecord::Schema.define(version: 20160403030707) do

  create_table "add_books", force: :cascade do |t|
    t.string   "cover_file_name"
    t.string   "cover_content_type"
    t.integer  "cover_file_size"
    t.datetime "cover_updated_at"
    t.string   "title"
    t.string   "author_first_name"
    t.string   "author_last_name"
    t.boolean  "part_of_series"
    t.string   "series_name"
    t.integer  "series_number"
    t.integer  "pages"
    t.decimal  "rating"
    t.string   "publisher"
    t.time     "published_date"
    t.integer  "isbn10"
    t.integer  "isbn13"
    t.string   "genre"
    t.string   "link"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
  end

  create_table "authors", force: :cascade do |t|
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "bio"
    t.string   "other_books"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
  end

  create_table "genres", force: :cascade do |t|
    t.string   "book_type"
    t.string   "genre"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
