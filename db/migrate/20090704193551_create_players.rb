class CreatePlayers < ActiveRecord::Migration
  def self.up
    create_table :players do |t|
      t.column :number, :integer
      t.column :last_name, :string
      t.column :first_name, :string
      t.column :position, :string
      t.column :height, :string
      t.column :weight, :string
      t.column :year, :string
      t.column :hometown, :string
      t.column :previous_school, :string
      t.column :active, :boolean, :default => true
      t.timestamps
    end
  end

  def self.down
    drop_table :players
  end
end
