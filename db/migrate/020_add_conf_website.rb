class AddConfWebsite < ActiveRecord::Migration
  def self.up
    add_column :conferences, :website, :string
  end

  def self.down
    remove_column :conferences, :website
  end
end
