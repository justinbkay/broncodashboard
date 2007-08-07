class AddGameFields < ActiveRecord::Migration
  def self.up
    add_column :games, :week_id, :integer
    add_column :games, :home_team_id, :integer
    add_column :games, :visitor_team_id, :integer
    add_column :games, :home_score, :integer, :default => 0
    add_column :games, :visitor_score, :integer, :default => 0
    add_column :games, :stadium_id, :integer
    add_column :games, :overtime, :boolean, :default => false
    add_column :games, :game_time, :datetime
  end

  def self.down
    remove_column :games, :week_id
    remove_column :games, :home_team_id
    remove_column :games, :visitor_team_id
    remove_column :games, :home_score
    remove_column :games, :visitor_score
    remove_column :games, :stadium_id
    remove_column :games, :overtime
    remove_column :games, :game_time
  end
end
