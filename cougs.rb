require 'rubygems'
require 'open-uri'
require 'hpricot'
require 'mysql2'
require 'active_record'


class Bdb_production < ActiveRecord::Base
 self.abstract_class = true
 establish_connection(
        :adapter => "mysql",
        :host     => "localhost",
        :username => "root",
        :password => "jamon0665",
        :database => "broncodashboard_production"
 )
end
class Player < Bdb_production
  validates_presence_of :number, :on => :create, :message => "can't be blank"

  def to_s
    [number, first_name, last_name, position, height, weight, year, hometown, previous_school, website_key].join(', ')
  end
end
@players = Player.all(:conditions => 'team_id=43')

#@players.each do |p|
#  p.destroy
#end

aruba = Hpricot(open("http://byucougars.com/roster/m-football"))

aruba.search("//#roster-table").search("//tr").each_with_index do |row, index|

 next if index == 0
 results = row.search("//td")

 # puts results[1].search("//a")[0].get_attribute('href') 
 last_name = results[1].search("//a").inner_html.split(' ')[1] 

 first_name = results[1].search("//a").inner_html.split(' ')[0] 
 a = Player.new(:number => results[0].search("//a").inner_html,
               :first_name => first_name,
               :last_name => last_name,
               :position => results[4].search("//a").inner_html,
               :height => results[2].inner_html,
               :weight => results[3].inner_html,
               :year => results[5].search("//a").inner_html,
               :hometown => results[6].search("//a").inner_html,
               :team_id => 43,
               :previous_school => results[7].search("//a").inner_html,
               :website_key => 0,
	       :url => results[1].search("//a")[0].get_attribute('href'),
               :years_rostered => ''
               )
 puts a.to_s
end
