class AddTbaFlag < ActiveRecord::Migration
  def self.up
    add_column :games, :tba, :boolean, :default => false
  end

  def self.down
    remove_column :games, :tba
  end
end
