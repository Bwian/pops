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

ActiveRecord::Schema.define(version: 20131110101918) do

  create_table "orders", force: true do |t|
    t.integer  "supplier_id"
    t.string   "supplier_name"
    t.string   "invoice_no"
    t.date     "invoice_date"
    t.date     "payment_date"
    t.string   "reference"
    t.integer  "creator"
    t.datetime "created_at"
    t.integer  "approver"
    t.datetime "approved_at"
    t.integer  "processor"
    t.datetime "processed_at"
    t.datetime "updated_at"
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
  end

end
