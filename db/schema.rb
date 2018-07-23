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

ActiveRecord::Schema.define(version: 2018_07_23_123004) do

  create_table "clients_projects", id: false, force: :cascade do |t|
    t.integer "client_id", null: false
    t.integer "project_id", null: false
    t.index ["client_id"], name: "index_clients_projects_on_client_id"
    t.index ["project_id"], name: "index_clients_projects_on_project_id"
  end

  create_table "projects", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.string "attachments"
  end

  create_table "roles", force: :cascade do |t|
    t.integer "employee_id", null: false
    t.integer "project_id", null: false
    t.string "role"
  end

  create_table "tasks", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.string "attachments"
    t.string "status"
    t.string "priority"
    t.datetime "created_at"
    t.datetime "completed_at"
    t.datetime "started_at"
    t.datetime "ended_at"
    t.integer "employee_id"
    t.integer "project_id"
    t.index ["employee_id"], name: "index_tasks_on_employee_id"
    t.index ["project_id"], name: "index_tasks_on_project_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "username"
    t.text "first_name"
    t.text "last_name"
    t.string "country"
    t.string "company"
    t.string "type"
    t.string "attachment"
    t.string "function"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

end
