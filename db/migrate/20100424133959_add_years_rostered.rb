class AddYearsRostered < ActiveRecord::Migration
  def self.up
    add_column :players, :years_rostered, :string
  end

  def self.down
    remove_column :players, :years_rostered
  end
end
