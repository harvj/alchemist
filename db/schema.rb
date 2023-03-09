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

ActiveRecord::Schema[7.0].define(version: 2023_01_27_173931) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "cards", force: :cascade do |t|
    t.string "name"
    t.integer "base_offense"
    t.integer "base_defense"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "rarity"
    t.integer "form"
    t.integer "fusion"
    t.boolean "onyx_available", default: false
    t.integer "origin", default: 0
    t.index ["form"], name: "index_cards_on_form"
    t.index ["fusion"], name: "index_cards_on_fusion"
    t.index ["origin"], name: "index_cards_on_origin"
    t.index ["rarity"], name: "index_cards_on_rarity"
  end

  create_table "combos", force: :cascade do |t|
    t.integer "card_id"
    t.integer "match_id"
    t.integer "final_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "partner_id"
    t.index ["card_id"], name: "index_combos_on_card_id"
    t.index ["final_id"], name: "index_combos_on_final_id"
    t.index ["match_id"], name: "index_combos_on_match_id"
    t.index ["partner_id"], name: "index_combos_on_partner_id"
  end

  create_table "deck_cards", force: :cascade do |t|
    t.integer "deck_id"
    t.integer "card_id"
    t.integer "level"
    t.boolean "fused"
    t.integer "rarity"
    t.index ["card_id"], name: "index_deck_cards_on_card_id"
    t.index ["deck_id"], name: "index_deck_cards_on_deck_id"
    t.index ["level"], name: "index_deck_cards_on_level"
    t.index ["rarity"], name: "index_deck_cards_on_rarity"
  end

  create_table "decks", force: :cascade do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "name"
  end

  create_table "user_cards", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "card_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["card_id"], name: "index_user_cards_on_card_id"
    t.index ["user_id"], name: "index_user_cards_on_user_id"
  end

  create_table "user_combos", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "combo_id"
    t.datetime "researched"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["combo_id"], name: "index_user_combos_on_combo_id"
    t.index ["user_id"], name: "index_user_combos_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "username", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["username"], name: "index_users_on_username"
  end

end
