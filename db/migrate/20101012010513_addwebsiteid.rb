class Addwebsiteid < ActiveRecord::Migration
  def self.up
    add_column :games, :website_id, :string
  end

  def self.down
    remove_column :games, :website_id
  end
end
