class CreateBowls < ActiveRecord::Migration
  def self.up
    create_table :bowls do |t|
    end
  end

  def self.down
    drop_table :bowls
  end
end
