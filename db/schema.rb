# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 18) do

  create_table "global_settings", :force => true do |t|
    t.text    "settings"
    t.boolean "allow_change_mind",    :default => true,                                                                                                                                             :null => false
    t.boolean "show_categories",      :default => true,                                                                                                                                             :null => false
    t.boolean "allow_signup",         :default => true,                                                                                                                                             :null => false
    t.text    "welcome_title",        :default => "Hello, <strong>%name</strong>!",                                                                                                                 :null => false
    t.text    "welcome_text",         :default => "Think carefully about which topics you would like to learn more about so you can make the most of Symposium.",                                   :null => false
    t.text    "registration_closed",  :default => "Whoopsie! Symposium registration is now closed. If you didn't already register, you'll be assigned breakout sessions where space is available.", :null => false
    t.boolean "autofill_in_progress", :default => false
  end

  create_table "groups", :force => true do |t|
    t.string  "name"
    t.integer "capacity", :default => 50
  end

  create_table "lecture_categories", :force => true do |t|
    t.string "title"
  end

  create_table "lectures", :force => true do |t|
    t.string   "title"
    t.string   "presenter"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "category_id"
    t.string   "only_grades"
    t.boolean  "selectable",  :default => true, :null => false
    t.string   "room"
  end

  create_table "picks", :force => true do |t|
    t.integer "student_id"
    t.integer "lecture_id"
    t.integer "sort"
  end

  create_table "sections", :force => true do |t|
    t.integer "lecture_id"
    t.integer "group_id"
    t.integer "timeblock_id"
  end

  create_table "students", :force => true do |t|
    t.string   "name"
    t.integer  "grade"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "group_id"
  end

  create_table "timeblocks", :force => true do |t|
    t.integer  "length"
    t.integer  "order"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "accepts_lecture", :default => true, :null => false
  end

end
