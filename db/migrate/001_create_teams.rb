class CreateTeams < ActiveRecord::Migration
  def self.up
    create_table :teams do |t|
      t.column :name, :string
      t.column :stadium_id, :integer
      t.column :division_id, :string
      t.column :nickname, :string
      t.column :mascot, :string
      t.column :city, :string
      t.column :state, :string
      t.column :conference_id, :integer
    end
  end

  def self.down
    drop_table :teams
  end
end
