class AddCoachTeam < ActiveRecord::Migration
  def self.up
    add_column :teams, :coach, :string
    add_column :teams, :coach_hire_date, :date
    add_column :teams, :colors, :string
    add_column :games, :vegas_line, :string
  end

  def self.down
    remove_column :teams, :coach
    remove_column :teams, :coach_hire_date
    remove_column :teams, :colors
    remove_column :games, :vegas_line
  end
end
