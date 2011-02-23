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
 	:password => "nwrecc01",
 	:database => "broncodashboard_production"
 )
end
class Player < Bdb_production
  validates_presence_of :number, :on => :create, :message => "can't be blank"
end

@players = Player.all(:conditions => 'team_id=13')

@players.each do |p|
  p.destroy
end

aruba = Hpricot(open("http://hawaiiathletics.com/roster.aspx?path=football", "User-Agent" => "iWormy"))
aruba.search("//table[@class='default_dgrd roster_dgrd']//tr").each_with_index do |game, index|
 next if index == 0
 results = game.search("//td")
 a = Player.create(:number => results[0].inner_html.strip,
	               :first_name => results[2].inner_html.scan(/.*>(.*)<.*/)[0][0].strip.split[0],
	               :last_name => results[2].inner_html.scan(/.*>(.*)<.*/)[0][0].strip.split[1],
	               :position => results[3].inner_html.strip,
	               :height => results[4].inner_html.scan(/.*>(.*)<.*/)[0][0].strip,
	               :weight => results[5].inner_html.strip,
	               :year => results[6].inner_html.strip,
	               :website_key => results[2].inner_html.scan(/rp_id=(\d*)&/)[0][0].strip,
	               :hometown => results[7].inner_html.strip.split("/")[0].strip,
	               :team_id => 13,
	               :previous_school =>
results[7].inner_html.strip.split("/")[1].strip) 
	
 puts results[0].inner_html.strip + ' :: ' +
            #number
      results[2].inner_html.scan(/.*>(.*)<.*/)[0][0].strip + ' :: ' +
            #name
      results[3].inner_html.strip + ' :: ' +
            #position
      results[4].inner_html.scan(/.*>(.*)<.*/)[0][0].strip + ' :: ' +
            #height
      results[5].inner_html.strip + ' :: ' +
            #weight
      results[6].inner_html.strip + ' :: ' +
            #year
      results[7].inner_html.strip unless results[0].inner_html.strip== ''         #hometown/hs
end
