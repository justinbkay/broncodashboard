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
@players = Player.all(:conditions => 'team_id=43')

@players.each do |p|
  p.destroy
end

aruba = Hpricot(open("http://www.byucougars.com/Roster.jsp?SP=130&NUM"))
#b = a[0].parent.parent.children_of_type('tr')
aruba.search("//table//tr//th//span[@class='normRosterText']")[0].parent.parent.parent.children_of_type('tr').each_with_index do |row, index|
 next if index == 0
 results = row.search("//td//span")
 puts results[2].inner_html.strip.scan(/(\d-\d+)/)
  begin
    last_name = results[1].inner_html.scan(/<b>(.*)<\/b>/)[0][0].split('&nbsp;')[1]
  rescue
    last_name = results[1].inner_html.strip.scan(/\s+(.*)\s+/)[0][0].split('&nbsp;')[1]
  end

 begin
   first_name = results[1].inner_html.scan(/<b>(.*)<\/b>/)[0][0].split('&nbsp;')[0]
 rescue
   first_name = results[1].inner_html.strip.scan(/\s+(.*)\s+/)[0][0].split('&nbsp;')[0]
 end
 Player.create(:number => results[0].inner_html.strip.scan(/<b>(.*)<\/b>/)[0],
                     :first_name => first_name,
                          :last_name => last_name,
                          :position => results[4].inner_html.scan(/<b>(.*)<\/b>/)[0][0],
                          :height => results[2].inner_html.strip.scan(/(\d-\d+)/)[0][0],
                          :weight => results[3].inner_html.strip.scan(/(\d+)/)[0][0],
                          :year => results[5].inner_html.strip.scan(/(Fr.|So.|Jr.|Sr.)/)[0][0],
                          :hometown => results[6].inner_html.scan(/.*>(.*)<\//)[0][0].split("/")[0].strip,
                          :team_id => 43,
                          :previous_school => results[6].inner_html.scan(/.*>(.*)<\//)[0][0].split("/")[1].strip
                           )     
end