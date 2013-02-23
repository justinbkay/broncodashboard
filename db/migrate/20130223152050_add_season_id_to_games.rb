class AddSeasonIdToGames < ActiveRecord::Migration
  def change
    add_column :games, :season_id, :integer
  end
end
