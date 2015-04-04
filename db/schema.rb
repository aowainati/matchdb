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

ActiveRecord::Schema.define(version: 20150404051410) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "channels", force: :cascade do |t|
    t.string   "name"
    t.text     "desc"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.text     "title_regex_yaml"
  end

  create_table "characters", force: :cascade do |t|
    t.string   "name"
    t.integer  "game_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "aliases",                 array: true
  end

  add_index "characters", ["name", "game_id"], name: "index_characters_on_name_and_game_id", unique: true, using: :btree

  create_table "events", force: :cascade do |t|
    t.string    "name"
    t.daterange "duration"
    t.datetime  "created_at", null: false
    t.datetime  "updated_at", null: false
  end

  create_table "games", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "aliases",                 array: true
  end

  add_index "games", ["name"], name: "index_games_on_name", unique: true, using: :btree

  create_table "matches", force: :cascade do |t|
    t.string   "title"
    t.text     "youtube_id"
    t.integer  "event_id"
    t.integer  "game_id"
    t.json     "data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "channel_id"
  end

  add_index "matches", ["channel_id"], name: "index_matches_on_channel_id", using: :btree
  add_index "matches", ["event_id"], name: "index_matches_on_event_id", using: :btree
  add_index "matches", ["game_id"], name: "index_matches_on_game_id", using: :btree

  create_table "players", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "matches", "channels"
  add_foreign_key "matches", "events"
  add_foreign_key "matches", "games"
end
