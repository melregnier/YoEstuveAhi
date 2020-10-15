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

ActiveRecord::Schema.define(version: 2020_10_14_185003) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "covid_tests", force: :cascade do |t|
    t.date "date", null: false
    t.boolean "result", null: false
    t.bigint "user_id"
    t.index ["user_id"], name: "index_covid_tests_on_user_id"
  end

  create_table "locations", force: :cascade do |t|
    t.string "name", null: false
    t.integer "capacity", null: false
    t.decimal "latitude", precision: 10, scale: 6, null: false
    t.decimal "longitude", precision: 10, scale: 6, null: false
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_locations_on_user_id"
  end

  create_table "user_location_histories", force: :cascade do |t|
    t.datetime "check_in", null: false
    t.datetime "check_out", null: false
    t.bigint "user_id"
    t.bigint "location_id"
    t.index ["location_id"], name: "index_user_location_histories_on_location_id"
    t.index ["user_id"], name: "index_user_location_histories_on_user_id"
  end

  create_table "user_locations", force: :cascade do |t|
    t.datetime "check_in", null: false
    t.bigint "user_id"
    t.bigint "location_id"
    t.index ["location_id"], name: "index_user_locations_on_location_id"
    t.index ["user_id"], name: "index_user_locations_on_user_id"
  end

  create_table "user_logs", force: :cascade do |t|
    t.datetime "created_at"
    t.string "to_state"
    t.bigint "user_id"
    t.index ["user_id"], name: "index_user_logs_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name", null: false
    t.string "document_type", null: false
    t.integer "document_number", null: false
    t.string "email", null: false
    t.string "password_digest", null: false
    t.string "state", default: "healthy"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "covid_tests", "users"
  add_foreign_key "locations", "users"
  add_foreign_key "user_location_histories", "locations"
  add_foreign_key "user_location_histories", "users"
  add_foreign_key "user_locations", "locations"
  add_foreign_key "user_locations", "users"
  add_foreign_key "user_logs", "users"
end
