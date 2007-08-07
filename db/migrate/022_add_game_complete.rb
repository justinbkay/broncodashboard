class AddGameComplete < ActiveRecord::Migration
  def self.up
    add_column :games, :complete, :boolean, :default => false
  end

  def self.down
    remove_column :games, :complete
  end
end
