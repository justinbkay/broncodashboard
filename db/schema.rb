# This file is autogenerated. Instead of editing this file, please use the
# migrations feature of ActiveRecord to incrementally modify your database, and
# then regenerate this schema definition.

ActiveRecord::Schema.define(:version => 26) do

  create_table "bowls", :force => true do |t|
    t.column "name", :string
  end

  create_table "conferences", :force => true do |t|
    t.column "name",         :string
    t.column "division_id",  :integer
    t.column "commissioner", :string
    t.column "short_name",   :string
    t.column "website",      :string
  end

  create_table "divisions", :force => true do |t|
    t.column "name", :string
  end

  create_table "games", :force => true do |t|
    t.column "week_id",                   :integer
    t.column "home_team_id",              :integer
    t.column "visitor_team_id",           :integer
    t.column "home_score",                :integer,  :default => 0
    t.column "visitor_score",             :integer,  :default => 0
    t.column "stadium_id",                :integer
    t.column "overtime",                  :boolean,  :default => false
    t.column "game_time",                 :datetime
    t.column "home_team_ap_rank",         :string
    t.column "visitor_team_ap_rank",      :string
    t.column "home_team_coaches_rank",    :string
    t.column "visitor_team_coaches_rank", :string
    t.column "home_team_bcs_rank",        :string
    t.column "visitor_team_bcs_rank",     :string
    t.column "media",                     :string
    t.column "complete",                  :boolean,  :default => false
    t.column "vegas_line",                :string
  end

  create_table "schedules", :force => true do |t|
  end

  create_table "seasons", :force => true do |t|
    t.column "name", :string
  end

  create_table "stadia", :force => true do |t|
    t.column "name",     :string
    t.column "city",     :string
    t.column "state",    :string
    t.column "capacity", :string
    t.column "lat",      :string
    t.column "lng",      :string
  end

  create_table "teams", :force => true do |t|
    t.column "name",               :string
    t.column "stadium_id",         :integer
    t.column "division_id",        :integer
    t.column "nickname",           :string
    t.column "mascot",             :string
    t.column "city",               :string
    t.column "state",              :string
    t.column "conference_id",      :integer
    t.column "athletics_website",  :string
    t.column "university_website", :string
    t.column "logo",               :string
    t.column "coach",              :string
    t.column "coach_hire_date",    :date
    t.column "colors",             :string
  end

  create_table "weeks", :force => true do |t|
    t.column "season_id", :integer
    t.column "name",      :string
    t.column "order",     :integer
  end

end
