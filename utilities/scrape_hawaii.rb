require 'rubygems'
require 'open-uri'
require 'hpricot'
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
    [id, number, first_name, last_name, position, height, weight, year, website_key, hometown, previous_school, url].join(', ')
  end
end

@players = Player.all(:conditions => 'team_id=13')

@players.each do |p|
  p.destroy
end

aruba = Hpricot(open("http://hawaiiathletics.com/roster.aspx?path=football", "User-Agent" => "iWormy"))
aruba.search("//table[@class='default_dgrd roster_dgrd']//tr").each_with_index do |game, index|
 next if index == 0
 results = game.search("//td")
 if results[7].inner_html.force_encoding('UTF-8').include?("/")
  ht = results[7].inner_html.force_encoding('UTF-8').split("/")[0].strip
  ps = results[7].inner_html.force_encoding('UTF-8').split("/")[1].strip
  case 
  when ps.match(/(Community College)/)
    ps.gsub!("Community College", 'CC')
  when ps.match(/(Kamehameha Schools)/)
    ps = "Kamehameha Schools"
  when ps.match(/^Eastern A/)
    ps = "Eastern Arizona Coll."
  when ps.match(/City College of San Francisco/)
    ps = "City Coll of SF"
  when ps == "Anglican Church Grammer School"
    ps = "Anglican Church GS"
  when ps == "North Dakota State College of Science"
    ps = "ND St Coll of Science"
  when ps == "Long Beach Poly High School"
    ps = "Long Beach Poly HS"
  when ps == "Southern Oregon University"
    ps = "Southern Oregon U"
  when ps == "Mt. San Antonio College"
    ps = "Mt. San Antonio Coll"
  end
  
 else
  ht = ""
  ps = results[7].inner_html.strip
 end

 a = Player.create(:number => results[0].inner_html.strip,
                   :first_name => results[2].search("//a").inner_html.strip.split[0],
                   :last_name => results[2].search("//a").inner_html.strip.split[1],
                   :position => results[3].inner_html.strip,
                   :height => results[4].search("//nobr").inner_html.strip,
                   :weight => results[5].inner_html.strip,
                   :year => results[6].inner_html.strip,
                   :website_key => results[2].inner_html.scan(/rp_id=(\d*)&/)[0][0].strip,
                   :hometown => ht, 
                   :team_id => 13,
                   :previous_school => ps)

 puts a.to_s 
end
