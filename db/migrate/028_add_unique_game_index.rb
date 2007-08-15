class AddUniqueGameIndex < ActiveRecord::Migration
  def self.up
    add_index :games, [:week_id, :home_team_id, :visitor_team_id], :unique => true
    add_column :teams, :newspaper_website, :string
  end

  def self.down
    remove_index :games, :column => :week_id
    remove_column :teams, :newspaper_website
  end
end
