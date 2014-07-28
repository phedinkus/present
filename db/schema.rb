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

ActiveRecord::Schema.define(version: 20140729003235) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "entries", force: true do |t|
    t.integer  "projects_timesheet_id"
    t.integer  "day"
    t.integer  "presence",              default: 0
    t.integer  "hours"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "entries", ["projects_timesheet_id"], name: "index_entries_on_projects_timesheet_id", using: :btree

  create_table "github_accounts", force: true do |t|
    t.integer  "user_id"
    t.integer  "github_id"
    t.string   "login"
    t.string   "access_token"
    t.text     "scopes",       array: true
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "github_accounts", ["user_id"], name: "index_github_accounts_on_user_id", using: :btree

  create_table "projects", force: true do |t|
    t.string  "name"
    t.boolean "active", default: true
  end

  create_table "projects_timesheets", force: true do |t|
    t.integer "project_id"
    t.integer "timesheet_id"
  end

  add_index "projects_timesheets", ["project_id"], name: "index_projects_timesheets_on_project_id", using: :btree
  add_index "projects_timesheets", ["timesheet_id"], name: "index_projects_timesheets_on_timesheet_id", using: :btree

  create_table "timesheets", force: true do |t|
    t.integer  "user_id"
    t.integer  "year"
    t.integer  "month"
    t.integer  "day"
    t.text     "notes"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "timesheets", ["user_id"], name: "index_timesheets_on_user_id", using: :btree

  create_table "users", force: true do |t|
    t.string   "name"
    t.string   "session_token"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
