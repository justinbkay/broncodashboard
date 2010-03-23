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
end
@players = Player.all(:conditions => 'team_id=1')

@players.each do |p|
  p.destroy
end

aruba = Hpricot(open("http://www.broncosports.com/SportSelect.dbml?SPSID=48552&SPID=4061&DB_LANG=C&DB_OEM_ID=9900&SORT_ORDER=1&Q_SEASON=2010&PRINTABLE_PAGE="))
#b = a[0].parent.parent.children_of_type('tr')
aruba.search("//table//tr//td[@class='subhdr']")[0].parent.parent.children_of_type('tr').each_with_index do |row, index|
 next if index == 0
 results = row.search("//td")
puts index
 Player.create(:number => results[0].inner_html.strip.scan(/\d+/)[0],
	               :first_name => results[1].inner_html.scan(/.*>(.*)<.*/)[0][0].strip.split[1],
	               :last_name => results[1].inner_html.scan(/.*>(.*)<.*/)[0][0].strip.split[0].chomp(","),
	               :position => results[2].inner_html.strip,
	               :height => results[3].inner_html.strip,
	               :weight => results[4].inner_html.strip,
	               :year => results[5].inner_html.strip,
	               :hometown => results[6].inner_html.strip.split(" (")[0].strip,
	               :team_id => 1,
	               :previous_school => results[6].inner_html.strip.scan(/\(([\w+\s']+)\)?/)[0][0]
	               )     
end