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

ActiveRecord::Schema.define(version: 20150703134514) do

  create_table "customers", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "name"
  end

  create_table "orders", force: :cascade do |t|
    t.string   "name"
    t.integer  "quantity"
    t.text     "description"
    t.text     "note"
    t.string   "store"
    t.string   "image_link"
    t.date     "order_date"
    t.date     "receive_us"
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
  end

  add_index "orders", ["customer_id"], name: "index_orders_on_customer_id"
  add_index "orders", ["user_id"], name: "index_orders_on_user_id"

  create_table "users", force: :cascade do |t|
    t.string   "name"
    t.string   "email"
    t.string   "password_digest"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.string   "remember_digest"
    t.decimal  "setting_vnd"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true

end
