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

ActiveRecord::Schema[8.0].define(version: 2025_04_27_023510) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "chat_users", force: :cascade do |t|
    t.bigint "chat_id", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["chat_id"], name: "index_chat_users_on_chat_id"
    t.index ["user_id"], name: "index_chat_users_on_user_id"
  end

  create_table "chats", force: :cascade do |t|
    t.string "token", null: false
    t.bigint "creator_id", null: false
    t.string "subject", default: "pending", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["creator_id"], name: "index_chats_on_creator_id"
    t.index ["token"], name: "index_chats_on_token", unique: true
  end

  create_table "languages", force: :cascade do |t|
    t.string "name", null: false
    t.string "icon", null: false
    t.string "name_english", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_languages_on_name", unique: true
    t.index ["name_english"], name: "index_languages_on_name_english", unique: true
  end

  create_table "messages", force: :cascade do |t|
    t.bigint "chat_id", null: false
    t.bigint "author_id", null: false
    t.text "content", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "original_language_id", null: false
    t.index ["author_id"], name: "index_messages_on_author_id"
    t.index ["chat_id"], name: "index_messages_on_chat_id"
    t.index ["original_language_id"], name: "index_messages_on_original_language_id"
  end

  create_table "translations", force: :cascade do |t|
    t.bigint "message_id", null: false
    t.bigint "language_id", null: false
    t.text "content", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["language_id"], name: "index_translations_on_language_id"
    t.index ["message_id", "language_id"], name: "index_translations_on_message_id_and_language_id", unique: true
    t.index ["message_id"], name: "index_translations_on_message_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name", default: "pending", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "preferred_language_id", null: false
    t.index ["preferred_language_id"], name: "index_users_on_preferred_language_id"
  end

  add_foreign_key "chat_users", "chats"
  add_foreign_key "chat_users", "users"
  add_foreign_key "chats", "users", column: "creator_id"
  add_foreign_key "messages", "chats"
  add_foreign_key "messages", "languages", column: "original_language_id"
  add_foreign_key "messages", "users", column: "author_id"
  add_foreign_key "translations", "languages"
  add_foreign_key "translations", "messages"
  add_foreign_key "users", "languages", column: "preferred_language_id"
end
