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

ActiveRecord::Schema[8.0].define(version: 2025_03_23_023759) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "actions", force: :cascade do |t|
    t.string "user_fullname"
    t.integer "type"
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.bigint "project_id", null: false
    t.bigint "project_entry_id", null: false
    t.index ["project_entry_id"], name: "index_actions_on_project_entry_id"
    t.index ["project_id"], name: "index_actions_on_project_id"
    t.index ["user_id"], name: "index_actions_on_user_id"
  end

  create_table "comments", force: :cascade do |t|
    t.string "title"
    t.string "author_fullname"
    t.string "body"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.bigint "project_id", null: false
    t.bigint "project_entry_id", null: false
    t.bigint "action_id", null: false
    t.index ["action_id"], name: "index_comments_on_action_id"
    t.index ["project_entry_id"], name: "index_comments_on_project_entry_id"
    t.index ["project_id"], name: "index_comments_on_project_id"
    t.index ["user_id"], name: "index_comments_on_user_id"
  end

  create_table "project_entries", force: :cascade do |t|
    t.string "creator_fullname"
    t.string "assigned_fullname"
    t.string "title"
    t.integer "priority"
    t.string "description"
    t.integer "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "project_id", null: false
    t.bigint "user_id", null: false
    t.index ["project_id"], name: "index_project_entries_on_project_id"
    t.index ["user_id"], name: "index_project_entries_on_user_id"
  end

  create_table "project_users", id: false, force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "project_id"
    t.index ["project_id"], name: "index_project_users_on_project_id"
    t.index ["user_id"], name: "index_project_users_on_user_id"
  end

  create_table "projects", force: :cascade do |t|
    t.string "title"
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["user_id"], name: "index_projects_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "first_name"
    t.string "last_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "actions", "project_entries"
  add_foreign_key "actions", "projects"
  add_foreign_key "actions", "users"
  add_foreign_key "comments", "actions"
  add_foreign_key "comments", "project_entries"
  add_foreign_key "comments", "projects"
  add_foreign_key "comments", "users"
  add_foreign_key "project_entries", "projects"
  add_foreign_key "project_entries", "users"
  add_foreign_key "projects", "users"
end
