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

ActiveRecord::Schema.define(:version => 20131122191832) do

  create_table "base_data", :force => true do |t|
    t.string   "type",                        :null => false
    t.integer  "code",        :default => 0
    t.integer  "point",       :default => 0
    t.integer  "node_cnt",    :default => 0
    t.string   "description", :default => ""
    t.datetime "created_at",                  :null => false
    t.datetime "updated_at",                  :null => false
  end

  create_table "facebooks", :force => true do |t|
    t.string   "uid"
    t.string   "user_id"
    t.string   "name"
    t.string   "gender"
    t.string   "locale"
    t.string   "oauth_token"
    t.string   "oauth_expires_at"
    t.string   "m_oauth_token"
    t.string   "m_oauth_expires_at"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
  end

  create_table "point_logs", :force => true do |t|
    t.integer  "user_id"
    t.integer  "your_id"
    t.integer  "type"
    t.integer  "point"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "ip"
    t.string   "facebook_uid"
    t.integer  "facebook_id"
    t.string   "username",     :default => "baby"
    t.integer  "point",        :default => 0
    t.string   "color",        :default => "255/255/255"
    t.string   "banner",       :default => "hello world"
    t.integer  "node_cnt",     :default => 1
    t.datetime "created_at",                              :null => false
    t.datetime "updated_at",                              :null => false
    t.string   "ancestry"
  end

end
