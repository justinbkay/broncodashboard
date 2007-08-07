class AddCapacityStadium < ActiveRecord::Migration
  def self.up
    add_column :stadia, :capacity, :string
  end

  def self.down
    remove_column :stadia, :capacity
  end
end
