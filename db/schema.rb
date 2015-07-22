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

ActiveRecord::Schema.define(version: 20150722101825) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "activities", force: :cascade do |t|
    t.integer  "trackable_id"
    t.string   "trackable_type"
    t.integer  "owner_id"
    t.string   "owner_type"
    t.string   "key"
    t.text     "parameters"
    t.integer  "recipient_id"
    t.string   "recipient_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "activities", ["owner_id", "owner_type"], name: "index_activities_on_owner_id_and_owner_type", using: :btree
  add_index "activities", ["recipient_id", "recipient_type"], name: "index_activities_on_recipient_id_and_recipient_type", using: :btree
  add_index "activities", ["trackable_id", "trackable_type"], name: "index_activities_on_trackable_id_and_trackable_type", using: :btree

  create_table "customers", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "name"
    t.integer  "user_id"
    t.text     "address"
    t.text     "bank"
  end

  add_index "customers", ["user_id"], name: "index_customers_on_user_id", using: :btree

  create_table "data", force: :cascade do |t|
    t.decimal  "total_cost"
    t.decimal  "total_selling"
    t.decimal  "revenue"
    t.integer  "order_sold"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.date     "month_record"
    t.integer  "user_id"
  end

  add_index "data", ["user_id"], name: "index_data_on_user_id", using: :btree

  create_table "orders", force: :cascade do |t|
    t.text     "description"
    t.text     "note"
    t.string   "store"
    t.string   "image_link"
    t.date     "order_date"
    t.date     "ship_vn"
    t.decimal  "web_price"
    t.decimal  "tax"
    t.decimal  "shipping_us"
    t.decimal  "reward"
    t.decimal  "shipping_vn"
    t.decimal  "total"
    t.decimal  "total_cost"
    t.decimal  "vnd"
    t.decimal  "profit"
    t.decimal  "deposit"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.decimal  "selling_price"
    t.integer  "user_id"
    t.integer  "customer_id"
    t.boolean  "received_us"
    t.string   "web_order_id"
    t.decimal  "remain"
    t.integer  "shipping_id"
    t.integer  "datum_id"
  end

  add_index "orders", ["customer_id"], name: "index_orders_on_customer_id", using: :btree
  add_index "orders", ["datum_id"], name: "index_orders_on_datum_id", using: :btree
  add_index "orders", ["shipping_id"], name: "index_orders_on_shipping_id", using: :btree
  add_index "orders", ["user_id"], name: "index_orders_on_user_id", using: :btree

  create_table "shippings", force: :cascade do |t|
    t.decimal  "price"
    t.date     "ship_date"
    t.text     "description"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.text     "order_fields"
  end

  create_table "users", force: :cascade do |t|
    t.string   "name"
    t.string   "email"
    t.string   "password_digest"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.string   "remember_digest"
    t.decimal  "setting_vnd"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree

  add_foreign_key "orders", "data"
end
