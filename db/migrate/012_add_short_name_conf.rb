class AddShortNameConf < ActiveRecord::Migration
  def self.up
    add_column :conferences, :short_name, :string
  end

  def self.down
    remove_column :conferences, :short_name
  end
end
