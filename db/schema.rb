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

ActiveRecord::Schema.define(version: 20150609053948) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "activity_logs", force: true do |t|
    t.integer  "organization_id"
    t.string   "description"
    t.datetime "done_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "category"
  end

  create_table "inventories", force: true do |t|
    t.string   "csv_file"
    t.integer  "organization_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "published",       default: false
    t.datetime "publish_date"
    t.string   "author"
  end

  add_index "inventories", ["organization_id"], name: "index_inventories_on_organization_id", using: :btree

  create_table "officials", force: true do |t|
    t.integer  "opening_plan_id"
    t.string   "name"
    t.string   "position"
    t.integer  "kind"
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "officials", ["opening_plan_id"], name: "index_officials_on_opening_plan_id", using: :btree

  create_table "opening_plans", force: true do |t|
    t.integer  "organization_id"
    t.text     "vision"
    t.text     "name"
    t.text     "description"
    t.date     "publish_date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "opening_plans", ["organization_id"], name: "index_opening_plans_on_organization_id", using: :btree

  create_table "organizations", force: true do |t|
    t.string   "title"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "slug"
    t.text     "description"
    t.string   "logo_url"
  end

  add_index "organizations", ["slug"], name: "index_organizations_on_slug", unique: true, using: :btree

  create_table "roles", force: true do |t|
    t.string   "name"
    t.integer  "resource_id"
    t.string   "resource_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "roles", ["name", "resource_type", "resource_id"], name: "index_roles_on_name_and_resource_type_and_resource_id", using: :btree
  add_index "roles", ["name"], name: "index_roles_on_name", using: :btree

  create_table "users", force: true do |t|
    t.string   "name",                   default: "", null: false
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "organization_id"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["organization_id"], name: "index_users_on_organization_id", using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  create_table "users_roles", id: false, force: true do |t|
    t.integer "user_id"
    t.integer "role_id"
  end

  add_index "users_roles", ["user_id", "role_id"], name: "index_users_roles_on_user_id_and_role_id", using: :btree

end
