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

ActiveRecord::Schema.define(version: 20160118073102) do

  create_table "options", force: :cascade do |t|
    t.integer  "poll_id",    limit: 4
    t.string   "text",       limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "options", ["poll_id"], name: "index_options_on_poll_id", using: :btree

  create_table "polls", force: :cascade do |t|
    t.integer  "user_id",    limit: 4
    t.string   "question",   limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "polls", ["user_id"], name: "index_polls_on_user_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "name",            limit: 255
    t.string   "email",           limit: 255
    t.string   "password_digest", limit: 255
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
  end

  create_table "voted_options_voters", id: false, force: :cascade do |t|
    t.integer  "user_id",    limit: 4
    t.integer  "option_id",  limit: 4
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  add_index "voted_options_voters", ["user_id", "option_id"], name: "index_voted_options_voters_on_user_id_and_option_id", using: :btree

end
