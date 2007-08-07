class CreateSchedules < ActiveRecord::Migration
  def self.up
    create_table :schedules do |t|
    end
  end

  def self.down
    drop_table :schedules
  end
end
