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
@players = Player.all(:conditions => 'team_id=12')

@players.each do |p|
  p.destroy
end

aruba = Hpricot(open("http://www.govandals.com/SportSelect.dbml?SPSID=87198&SPID=10352&DB_OEM_ID=17100&SORT_ORDER=1&Q_SEASON=2010&PRINTABLE_PAGE="))
#b = a[0].parent.parent.children_of_type('tr')
aruba.search("//table//tr//td[@class='subhdr']")[0].parent.parent.children_of_type('tr').each_with_index do |row, index|
next if index == 0
 results = row.search("//td")
begin
  fname = results[1].inner_html.scan(/.*>(.*)<.*/)[0][0].strip.split(',')[1]
  lname = results[1].inner_html.scan(/.*>(.*)<.*/)[0][0].strip.split(',')[0]
rescue
  fname = results[1].inner_html.strip.split(',')[1]
  lname = results[1].inner_html.strip.split(',')[0]
end
Player.create(:number => results[0].inner_html.strip.scan(/\d+/)[0],
                :first_name => fname,
                :last_name => lname,
                :position => results[2].inner_html.strip,
                :height => results[3].inner_html.strip,
                :weight => results[4].inner_html.strip,
                :year => results[5].inner_html.strip,
                :hometown => results[6].inner_html.strip.split(" (")[0].strip,
                :team_id => 12,
                :previous_school => results[6].inner_html.strip.scan(/\(([\w+\s\.']+)\)?/)[0][0]
                )     
end