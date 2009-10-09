class AddTeamPlayer < ActiveRecord::Migration
  def self.up
    add_column :players, :team_id, :integer
    
    execute "update players set team_id=1"
  end

  def self.down
    remove_column :players, :team_id
  end
end
