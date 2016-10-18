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

ActiveRecord::Schema.define(version: 20161018211638) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "due_dates", force: :cascade do |t|
    t.string   "name"
    t.string   "descriptions"
    t.datetime "date"
    t.float    "progress"
    t.integer  "project_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  add_index "due_dates", ["project_id"], name: "index_due_dates_on_project_id", using: :btree

  create_table "projects", force: :cascade do |t|
    t.string   "name"
    t.text     "description"
    t.float    "current_progress"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "name"
    t.string   "email"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.integer  "score",                  default: 0
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.string   "provider"
    t.string   "uid"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  create_table "words", force: :cascade do |t|
    t.string   "lang_code1"
    t.string   "text1"
    t.string   "lang_code2"
    t.string   "text2"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "pos"
    t.integer  "user_id"
    t.string   "gender"
  end

  add_index "words", ["lang_code1", "lang_code2", "text1", "text2", "user_id"], name: "unique_word", unique: true, using: :btree
  add_index "words", ["user_id"], name: "index_words_on_user_id", using: :btree

  add_foreign_key "due_dates", "projects"
end
