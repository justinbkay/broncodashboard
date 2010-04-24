class AddPlayerKey < ActiveRecord::Migration
  def self.up
    add_column :players, :website_key, :integer
  end

  def self.down
    remove_column :players, :website_key
  end
end
