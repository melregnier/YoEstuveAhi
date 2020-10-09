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

ActiveRecord::Schema.define(version: 2020_10_09_204627) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "covid_tests", force: :cascade do |t|
    t.date "date"
    t.boolean "result"
    t.bigint "user_id"
    t.index ["user_id"], name: "index_covid_tests_on_user_id"
  end

  create_table "locations", force: :cascade do |t|
    t.string "name"
    t.integer "capacity"
    t.decimal "latitude", precision: 10, scale: 6
    t.decimal "longitide", precision: 10, scale: 6
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_locations_on_user_id"
  end

  create_table "user_location_histories", force: :cascade do |t|
    t.datetime "check_in"
    t.datetime "check_out"
    t.bigint "user_id"
    t.bigint "location_id"
    t.index ["location_id"], name: "index_user_location_histories_on_location_id"
    t.index ["user_id"], name: "index_user_location_histories_on_user_id"
  end

  create_table "user_locations", force: :cascade do |t|
    t.datetime "check_in"
    t.bigint "user_id"
    t.bigint "location_id"
    t.index ["location_id"], name: "index_user_locations_on_location_id"
    t.index ["user_id"], name: "index_user_locations_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "document_type"
    t.integer "document_number"
    t.string "email"
    t.string "password"
    t.string "status", default: "healthy"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "covid_tests", "users"
  add_foreign_key "locations", "users"
  add_foreign_key "user_location_histories", "locations"
  add_foreign_key "user_location_histories", "users"
  add_foreign_key "user_locations", "locations"
  add_foreign_key "user_locations", "users"
end
