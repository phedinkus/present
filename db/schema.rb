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

ActiveRecord::Schema.define(version: 20151007171852) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "accidental_pairings", force: :cascade do |t|
    t.integer  "user_id"
    t.text     "description"
    t.datetime "paired_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "clients", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.integer  "harvest_id"
    t.boolean  "active"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "emails", force: :cascade do |t|
    t.integer  "job_id"
    t.string   "mailer",     limit: 255
    t.string   "to",         limit: 255
    t.string   "subject",    limit: 255
    t.text     "body"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "entries", force: :cascade do |t|
    t.integer  "projects_timesheet_id"
    t.integer  "day"
    t.integer  "presence"
    t.decimal  "hours",                 default: 0.0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "location_id"
    t.integer  "updated_by_id"
  end

  add_index "entries", ["projects_timesheet_id", "day"], name: "index_entries_on_projects_timesheet_id_and_day", unique: true, using: :btree
  add_index "entries", ["projects_timesheet_id"], name: "index_entries_on_projects_timesheet_id", using: :btree
  add_index "entries", ["updated_by_id"], name: "index_entries_on_updated_by_id", using: :btree

  create_table "github_accounts", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "github_id"
    t.string   "login",        limit: 255
    t.string   "access_token", limit: 255
    t.text     "scopes",                   array: true
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "email",        limit: 255
  end

  add_index "github_accounts", ["user_id"], name: "index_github_accounts_on_user_id", using: :btree

  create_table "invoices", force: :cascade do |t|
    t.integer  "project_id"
    t.integer  "year"
    t.integer  "month"
    t.integer  "day"
    t.integer  "harvest_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "jobs", force: :cascade do |t|
    t.string   "name",        limit: 255
    t.time     "finished_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "locations", force: :cascade do |t|
    t.string   "city",       limit: 255
    t.string   "state",      limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "missions", force: :cascade do |t|
    t.integer "user_id"
    t.integer "project_id"
    t.string  "project_placeholder_description"
    t.integer "year"
    t.integer "month"
    t.integer "status"
  end

  add_index "missions", ["user_id", "year", "month"], name: "index_missions_on_user_id_and_year_and_month", unique: true, using: :btree

  create_table "projects", force: :cascade do |t|
    t.string   "name",              limit: 255
    t.boolean  "active",                        default: true
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "client_id"
    t.integer  "harvest_id"
    t.integer  "weekly_rate"
    t.integer  "hourly_rate"
    t.integer  "rate_type",                     default: 0
    t.boolean  "requires_notes",                default: false
    t.boolean  "sticky",                        default: false
    t.boolean  "billable",                      default: true
    t.boolean  "manually_invoiced",             default: false
  end

  add_index "projects", ["client_id"], name: "index_projects_on_client_id", using: :btree

  create_table "projects_timesheets", force: :cascade do |t|
    t.integer  "project_id"
    t.integer  "timesheet_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "sent_to_harvest_at"
    t.text     "notes"
  end

  add_index "projects_timesheets", ["project_id"], name: "index_projects_timesheets_on_project_id", using: :btree
  add_index "projects_timesheets", ["timesheet_id", "project_id"], name: "index_projects_timesheets_on_timesheet_id_and_project_id", unique: true, using: :btree
  add_index "projects_timesheets", ["timesheet_id"], name: "index_projects_timesheets_on_timesheet_id", using: :btree

  create_table "system_configurations", force: :cascade do |t|
    t.integer "reference_invoice_year"
    t.integer "reference_invoice_month"
    t.integer "reference_invoice_day"
    t.integer "default_location_id"
  end

  create_table "timesheets", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "year"
    t.integer  "month"
    t.integer  "day"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "ready_to_invoice", default: false
  end

  add_index "timesheets", ["user_id", "year", "month", "day"], name: "index_timesheets_on_user_id_and_year_and_month_and_day", unique: true, using: :btree
  add_index "timesheets", ["user_id"], name: "index_timesheets_on_user_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "name",                        limit: 255
    t.string   "session_token",               limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "location_id"
    t.boolean  "active",                                  default: true,         null: false
    t.integer  "days_between_pair_reminders"
    t.boolean  "full_time",                               default: true,         null: false
    t.date     "hire_date",                               default: '2014-12-31', null: false
    t.string   "phone_number"
    t.string   "email"
    t.string   "twitter_handle"
    t.string   "tagline"
  end

end
