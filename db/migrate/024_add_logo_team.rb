class AddLogoTeam < ActiveRecord::Migration
  def self.up
    add_column :teams, :logo, :string
  end

  def self.down
    remove_column :teams, :logo
  end
end
