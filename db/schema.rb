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

ActiveRecord::Schema.define(version: 20140515140827) do

  create_table "accounts", force: true do |t|
    t.string  "name"
    t.integer "tax_rate_id"
    t.string  "status"
  end

  add_index "accounts", ["tax_rate_id"], name: "index_accounts_on_tax_rate_id"

  create_table "items", force: true do |t|
    t.integer  "order_id"
    t.integer  "program_id"
    t.integer  "account_id"
    t.integer  "tax_rate_id"
    t.string   "description"
    t.integer  "quantity"
    t.decimal  "price"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "items", ["order_id"], name: "index_items_on_order_id"

  create_table "notes", force: true do |t|
    t.integer  "order_id"
    t.integer  "user_id"
    t.text     "info"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "notes", ["order_id"], name: "index_notes_on_order_id"

  create_table "orders", force: true do |t|
    t.integer  "supplier_id"
    t.string   "supplier_name"
    t.string   "invoice_no"
    t.date     "invoice_date"
    t.date     "payment_date"
    t.string   "reference"
    t.integer  "creator_id"
    t.datetime "created_at"
    t.integer  "approver_id"
    t.datetime "approved_at"
    t.integer  "processor_id"
    t.datetime "processed_at"
    t.string   "status"
    t.datetime "updated_at"
    t.text     "delivery_address"
  end

  add_index "orders", ["approver_id"], name: "index_orders_on_approver_id"
  add_index "orders", ["creator_id"], name: "index_orders_on_creator_id"
  add_index "orders", ["processor_id"], name: "index_orders_on_processor_id"
  add_index "orders", ["supplier_id"], name: "index_orders_on_supplier_id"

  create_table "programs", force: true do |t|
    t.string "name"
    t.string "status"
  end

  create_table "suppliers", force: true do |t|
    t.string  "name"
    t.string  "address1"
    t.string  "address2"
    t.string  "address3"
    t.string  "phone"
    t.string  "fax"
    t.string  "email"
    t.integer "tax_rate_id"
    t.string  "status"
  end

  create_table "tax_rates", force: true do |t|
    t.string  "name"
    t.string  "short_name"
    t.decimal "rate"
    t.string  "status"
  end

  create_table "users", force: true do |t|
    t.string   "code"
    t.string   "name"
    t.string   "hashed_password"
    t.string   "salt"
    t.string   "email"
    t.integer  "approver_id"
    t.boolean  "creator",         default: true
    t.boolean  "approver",        default: false
    t.boolean  "processor",       default: false
    t.boolean  "admin",           default: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "phone"
    t.string   "accounts_filter"
    t.string   "programs_filter"
  end

end
