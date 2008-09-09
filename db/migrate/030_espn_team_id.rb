class EspnTeamId < ActiveRecord::Migration
  def self.up
    add_column :teams, :espn_id, :integer
  end

  def self.down
    remove_column :teams, :espn_id
  end
end
