class AddGameMedia < ActiveRecord::Migration
  def self.up
    add_column :games, :media, :string
  end

  def self.down
    remove_column :games, :media
  end
end
