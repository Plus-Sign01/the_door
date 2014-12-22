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

ActiveRecord::Schema.define(version: 20141222043225) do

  create_table "participations", force: true do |t|
    t.integer  "user_id"
    t.integer  "project_id"
    t.string   "school"
    t.string   "skill"
    t.string   "comment"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "participations", ["project_id"], name: "index_participations_on_project_id"
  add_index "participations", ["user_id", "project_id"], name: "index_participations_on_user_id_and_project_id", unique: true
  add_index "participations", ["user_id"], name: "index_participations_on_user_id"

  create_table "projects", force: true do |t|
    t.string   "name"
    t.string   "place"
    t.datetime "start_time"
    t.datetime "end_time"
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "name"
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "password_digest"
    t.string   "remember_token"
    t.boolean  "admin",           default: false
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["remember_token"], name: "index_users_on_remember_token"

end
