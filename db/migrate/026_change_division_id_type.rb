class ChangeDivisionIdType < ActiveRecord::Migration
  def self.up
    change_column 'teams', 'division_id', :integer
  end

  def self.down
    change_column 'teams', 'division_id', :string
  end
end
