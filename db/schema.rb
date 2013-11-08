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

ActiveRecord::Schema.define(version: 20131108132100) do

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
