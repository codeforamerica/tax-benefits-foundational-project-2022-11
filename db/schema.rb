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

ActiveRecord::Schema[7.0].define(version: 2022_12_06_214009) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "benefit_apps", force: :cascade do |t|
    t.string "address"
    t.string "phone_number", limit: 10
    t.string "email_address"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "primary_member_id"
    t.date "submitted_at"
    t.index ["primary_member_id"], name: "index_benefit_apps_on_primary_member_id"
  end

  create_table "members", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.datetime "date_of_birth"
    t.bigint "benefit_app_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["benefit_app_id"], name: "index_members_on_benefit_app_id"
  end

  add_foreign_key "benefit_apps", "members", column: "primary_member_id"
  add_foreign_key "members", "benefit_apps"
end
