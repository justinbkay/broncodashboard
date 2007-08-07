class AddWeekInfo < ActiveRecord::Migration
  def self.up
    add_column :weeks, :season_id, :integer
    add_column :weeks, :name, :string
    add_column :weeks, :order, :integer
  end

  def self.down
    remove_column :weeks, :season_id
    remove_column :weeks, :name
    remove_column :weeks, :order
  end
end
