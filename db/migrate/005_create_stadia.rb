class CreateStadia < ActiveRecord::Migration
  def self.up
    create_table :stadia do |t|
      t.column :name, :string
      t.column :city, :string
      t.column :state, :string
    end
  end

  def self.down
    drop_table :stadia
  end
end
