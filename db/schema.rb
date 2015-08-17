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

ActiveRecord::Schema.define(version: 20150817013630) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "chat_sessions", force: :cascade do |t|
    t.string   "session_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text     "chat_json"
  end

  add_index "chat_sessions", ["session_id"], name: "index_chat_sessions_on_session_id", using: :btree

  create_table "predicates", force: :cascade do |t|
    t.integer  "chat_session_id"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.text     "predicates_json"
  end

  add_index "predicates", ["chat_session_id"], name: "index_predicates_on_chat_session_id", using: :btree

end
