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

ActiveRecord::Schema.define(version: 20131026145650) do

  create_table "pads", force: :cascade do |t|
    t.string   "key",          limit: 10,   null: false
    t.string   "revision",                  null: false
    t.text     "content",      limit: 1024
    t.boolean  "is_autosaved",              null: false
    t.boolean  "is_deleted",                null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "pads", ["key", "revision", "is_autosaved", "is_deleted"], name: "index_pads_on_key_and_revision_and_is_autosaved_and_is_deleted"
  add_index "pads", ["key", "revision", "is_deleted"], name: "index_pads_on_key_and_revision_and_is_deleted", unique: true

end
