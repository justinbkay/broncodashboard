class AddLatLngStadia < ActiveRecord::Migration
  def self.up
    add_column :stadia, :lat, :string
    add_column :stadia, :lng, :string
  end

  def self.down
    remove_column :stadia, :lat
    remove_column :stadia, :lng
  end
end
