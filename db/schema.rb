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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 0) do

  create_table "admins", :force => true do |t|
    t.string   "username",   :limit => 32, :null => false
    t.string   "password",   :limit => 32, :null => false
    t.datetime "last_login"
    t.datetime "created_at"
  end

  add_index "admins", ["username", "password"], :name => "index_admins_on_username_and_password"

  create_table "pages", :id => false, :force => true do |t|
    t.string   "url_mapping",        :limit => 32,                   :null => false
    t.string   "display_name",       :limit => 32,                   :null => false
    t.text     "message",                                            :null => false
    t.datetime "start_time",                                         :null => false
    t.string   "lover_name",         :limit => 32,                   :null => false
    t.string   "your_name",          :limit => 32,                   :null => false
    t.string   "page_key",           :limit => 32,                   :null => false
    t.integer  "view_count",                       :default => 1
    t.integer  "interval",                         :default => 5000
    t.integer  "typewriter_speed",                 :default => 75
    t.integer  "loveheart_speed",                  :default => 50
    t.integer  "signature_interval",               :default => 3000
    t.integer  "words_interval",                   :default => 5000
    t.datetime "created_at"
  end

end
