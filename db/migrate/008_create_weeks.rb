class CreateWeeks < ActiveRecord::Migration
  def self.up
    create_table :weeks do |t|
    end
  end

  def self.down
    drop_table :weeks
  end
end
