class CreateGames < ActiveRecord::Migration
  def self.up
    create_table :games do |t|
    end
  end

  def self.down
    drop_table :games
  end
end
