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

ActiveRecord::Schema.define(version: 20151201060248) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "cards", force: true do |t|
    t.string   "name"
    t.string   "color"
    t.integer  "base_offense"
    t.integer  "base_defense"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "classification"
    t.integer  "score"
  end

  create_table "combos", force: true do |t|
    t.integer  "card_id"
    t.integer  "match_id"
    t.integer  "final_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float    "score"
    t.float    "onyx_score"
    t.integer  "partner_id"
  end

  add_index "combos", ["card_id"], name: "index_combos_on_card_id", using: :btree
  add_index "combos", ["final_id"], name: "index_combos_on_final_id", using: :btree
  add_index "combos", ["match_id"], name: "index_combos_on_match_id", using: :btree

  create_table "deck_cards", force: true do |t|
    t.integer "deck_id"
    t.integer "card_id"
    t.integer "level"
    t.boolean "fused"
    t.string  "color"
  end

  create_table "decks", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
