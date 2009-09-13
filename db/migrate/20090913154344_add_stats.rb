class AddStats < ActiveRecord::Migration
  def self.up
    add_column :games, :home_passing_yards, :integer, :default => 0
    add_column :games, :home_rushing_yards, :integer, :default => 0
    add_column :games, :visitor_passing_yards, :integer, :default => 0
    add_column :games, :visitor_rushing_yards, :integer, :default => 0
    add_column :games, :attendance, :integer, :default => 0
  end

  def self.down
    remove_column :games, :attendance
    remove_column :games, :visitor_rushing_yards
    remove_column :games, :visitor_passing_yards
    remove_column :games, :home_rushing_yards
    remove_column :games, :home_passing_yards
  end
end
