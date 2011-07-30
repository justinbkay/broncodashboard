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

ActiveRecord::Schema.define(:version => 20110730214533) do

  create_table "bowls", :force => true do |t|
    t.string "name"
  end

  create_table "conferences", :force => true do |t|
    t.string  "name"
    t.integer "division_id"
    t.string  "commissioner"
    t.string  "short_name"
    t.string  "website"
    t.integer "espn_id"
  end

  create_table "divisions", :force => true do |t|
    t.string "name"
  end

  create_table "games", :force => true do |t|
    t.integer  "week_id"
    t.integer  "home_team_id"
    t.integer  "visitor_team_id"
    t.integer  "home_score",                :default => 0
    t.integer  "visitor_score",             :default => 0
    t.integer  "stadium_id"
    t.boolean  "overtime",                  :default => false
    t.datetime "game_time"
    t.string   "home_team_ap_rank"
    t.string   "visitor_team_ap_rank"
    t.string   "home_team_coaches_rank"
    t.string   "visitor_team_coaches_rank"
    t.string   "home_team_bcs_rank"
    t.string   "visitor_team_bcs_rank"
    t.string   "media"
    t.boolean  "complete",                  :default => false
    t.string   "vegas_line"
    t.boolean  "tba",                       :default => false
    t.integer  "home_passing_yards",        :default => 0
    t.integer  "home_rushing_yards",        :default => 0
    t.integer  "visitor_passing_yards",     :default => 0
    t.integer  "visitor_rushing_yards",     :default => 0
    t.integer  "attendance",                :default => 0
    t.string   "website_id"
  end

  add_index "games", ["week_id", "home_team_id", "visitor_team_id"], :name => "index_games_on_week_id_and_home_team_id_and_visitor_team_id", :unique => true

  create_table "players", :force => true do |t|
    t.integer  "number"
    t.string   "last_name"
    t.string   "first_name"
    t.string   "position"
    t.string   "height"
    t.string   "weight"
    t.string   "year"
    t.string   "hometown"
    t.string   "previous_school"
    t.boolean  "active",          :default => true
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "team_id"
    t.string   "years_rostered"
    t.integer  "website_key"
    t.string   "url"
  end

  create_table "schedules", :force => true do |t|
  end

  create_table "seasons", :force => true do |t|
    t.string "name"
  end

  create_table "stadia", :force => true do |t|
    t.string "name"
    t.string "city"
    t.string "state"
    t.string "capacity"
    t.string "lat"
    t.string "lng"
  end

  create_table "teams", :force => true do |t|
    t.string  "name"
    t.integer "stadium_id"
    t.integer "division_id"
    t.string  "nickname"
    t.string  "mascot"
    t.string  "city"
    t.string  "state"
    t.integer "conference_id"
    t.string  "athletics_website"
    t.string  "university_website"
    t.string  "logo"
    t.string  "coach"
    t.date    "coach_hire_date"
    t.string  "colors"
    t.string  "newspaper_website"
    t.integer "espn_id"
  end

  create_table "weeks", :force => true do |t|
    t.integer "season_id"
    t.string  "name"
    t.integer "week_order"
  end

end
