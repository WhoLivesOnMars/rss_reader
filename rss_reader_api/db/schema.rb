# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.0].define(version: 2025_10_20_171852) do
  create_table "feed_items", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "feed_id", null: false
    t.string "title"
    t.string "url", limit: 2048, null: false
    t.text "summary"
    t.datetime "published_at"
    t.boolean "read", default: false, null: false
    t.string "guid", limit: 1024, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["feed_id"], name: "index_feed_items_on_feed_id"
    t.index ["guid"], name: "index_feed_items_on_guid", unique: true, length: 191
    t.index ["url"], name: "index_feed_items_on_url", length: 191
  end

  create_table "feeds", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "title"
    t.string "url"
    t.datetime "last_fetched_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "error_count"
    t.datetime "last_error_at"
    t.datetime "backoff_until"
    t.index ["url"], name: "index_feeds_on_url"
  end

  add_foreign_key "feed_items", "feeds"
end
