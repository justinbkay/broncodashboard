class AddTeamWebsite < ActiveRecord::Migration
  def self.up
    add_column :teams, :athletics_website, :string
    add_column :teams, :university_website, :string
    add_column :bowls, :name, :string
  end

  def self.down
    remove_column :teams, :athletics_website
    remove_column :teams, :university_website
    remove_column :bowls, :name
  end
end
