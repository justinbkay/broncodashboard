class AddApRankToGame < ActiveRecord::Migration
  def self.up
    add_column :games, :home_team_ap_rank, :string
    add_column :games, :visitor_team_ap_rank, :string
    add_column :games, :home_team_coaches_rank, :string
    add_column :games, :visitor_team_coaches_rank, :string
    add_column :games, :home_team_bcs_rank, :string
    add_column :games, :visitor_team_bcs_rank, :string
  end

  def self.down
    remove_column :games, :home_team_ap_rank
    remove_column :games, :visitor_team_ap_rank
    remove_column :games, :home_team_coaches_rank
    remove_column :games, :visitor_team_coaches_rank
    remove_column :games, :home_team_bcs_rank
    remove_column :games, :visitor_team_bcs_rank
  end
end
