class Addespnconfid < ActiveRecord::Migration
  def self.up
    add_column :conferences, :espn_id, :integer
  end

  def self.down
    remove_column :conferences, :espn_id
  end
end
