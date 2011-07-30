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
    [number, first_name, last_name, position, height, weight, year, hometown, website_key, previous_school].join(', ')
  end
end

@players = Player.all(:conditions => 'team_id=1')

@players.each do |p|
  p.destroy
end
aruba = Hpricot(open("http://www.broncosports.com/SportSelect.dbml?SPSID=48552&SPID=4061&DB_LANG=C&DB_OEM_ID=9900&SORT_ORDER=1&Q_SEASON=2011&PRINTABLE_PAGE="))

aruba.search("//table//tr//td[@class='subhdr']")[0].parent.parent.children_of_type('tr').each_with_index do |row, index|
 next if index == 0
 results = row.search("//td")
begin

  fname       = results[1].search("//a").search("//strong").inner_html.strip.split[1] ? results[1].search("//a").search("//strong").inner_html.strip.split[1] : results[1].search("//a").inner_html.strip.split[1]

  website_key = results[1].inner_html.scan(/ATCLID=(\d*)\&/)[0][0]

  lname       = results[1].search("//a").search("//strong").inner_html.strip.split[0] ? results[1].search("//a").search("//strong").inner_html.strip.split[0].chomp(",") : results[1].search("//a").inner_html.strip.split[0].chomp(",")  #results[1].inner_html.scan(/.*>(.*)<.*/)[0][0].strip.split[0].chomp(",")

rescue
  fname       = results[1].inner_html.strip.split[1]
  website_key = 0
  lname       = results[1].inner_html.strip.split[0].chomp(",")
end

a = Player.create(:number => results[0].inner_html.strip.scan(/\d+/)[0],
              :first_name => fname,
              :last_name => lname,
              :position => results[2].inner_html.strip,
              :height => results[3].inner_html.strip,
              :weight => results[4].inner_html.strip,
              :year => results[5].inner_html.strip,
              :hometown => results[6].inner_html.strip.split(" (")[0].strip.gsub(/(\n|\t)/,''),
              :team_id => 1,
              :website_key => website_key,
              :previous_school => results[6].inner_html.strip.scan(/\(([\w+\s']+)\)?/)[0][0]
              )        
puts a.to_s
end
