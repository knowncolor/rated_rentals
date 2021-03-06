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

ActiveRecord::Schema.define(version: 20140103144401) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "addresses", force: true do |t|
    t.string   "street_number"
    t.string   "route"
    t.string   "postal_town"
    t.string   "postal_code"
    t.string   "country"
    t.string   "decimal_degrees_latitude"
    t.string   "decimal_degrees_longitude"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "flat_number"
  end

  add_index "addresses", ["postal_code", "route", "street_number"], name: "index_addresses_on_postal_code_and_route_and_street_number", using: :btree

  create_table "reviews", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.date     "start_date"
    t.date     "end_date"
    t.integer  "furnishings_rating"
    t.integer  "noise_rating"
    t.integer  "amenities_rating"
    t.integer  "transport_rating"
    t.integer  "building_rating"
    t.string   "building_comments"
    t.string   "furnishings_comments"
    t.string   "noise_comments"
    t.string   "amenities_comments"
    t.string   "transport_comments"
    t.integer  "address_id"
    t.integer  "user_id"
  end

  create_table "users", force: true do |t|
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
    t.string   "provider"
    t.string   "uid"
    t.string   "name"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["name"], name: "index_users_on_name", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
