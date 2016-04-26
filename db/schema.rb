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

ActiveRecord::Schema.define(version: 20160425233950) do

  create_table "authors", force: :cascade do |t|
    t.string   "authors"
    t.string   "bio"
    t.string   "image_link_file_name"
    t.string   "image_link_content_type"
    t.integer  "image_link_file_size"
    t.datetime "image_link_updated_at"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  create_table "book_authors", force: :cascade do |t|
    t.integer  "book_id"
    t.integer  "genre_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "book_categories", force: :cascade do |t|
    t.integer  "book_id"
    t.integer  "category"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "book_genres", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "books", force: :cascade do |t|
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
    t.string   "image_link_file_name"
    t.string   "image_link_content_type"
    t.integer  "image_link_file_size"
    t.datetime "image_link_updated_at"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  create_table "categories", force: :cascade do |t|
    t.string   "categories"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "genres", force: :cascade do |t|
    t.string   "categories"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
