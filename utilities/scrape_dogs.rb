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

@players = Player.all(:conditions => 'team_id=9')

@players.each do |p|
  p.destroy
end

aruba = Hpricot(open("http://www.gobulldogs.com/sports/m-footbl/mtt/fres-m-footbl-mtt.html"))

aruba.search("//table//tr//td//font//b")[1].parent.parent.parent.parent.children_of_type('tr').each_with_index do |game, index|
 next if index == 0
 results = game.search("//td")
 a = Player.create(:number => results[0].search("//font").inner_html.strip,
                 :first_name => results[1].search("//font").inner_html.scan(/([\w\.]*)\s/)[0][0],
                 :last_name => results[1].search("//font").inner_html.scan(/\s(\w*)/)[0][0],
                 :position => results[2].search("//font").inner_html,
                 :height => results[3].search("//font").inner_html,
                 :weight => results[4].search("//font").inner_html,
                 :year => results[5].search("//font").inner_html,
                 :hometown => results[6].search("//font").inner_html.scan(/(.*)\s\(/)[0][0],
                 :team_id => 9,
                 :previous_school => results[6].search("//font").inner_html.scan(/\s\((.*)\)/)[0][0]) 
  
 puts results[0].search("//font").inner_html.strip + ' :: ' +
            #number
      results[1].search("//font").inner_html.scan(/([\w\.]*)\s/)[0][0] + ' :: ' +
            #first name
      results[1].search("//font").inner_html.scan(/\s(\w*)/)[0][0] + ' :: ' +
            #last
      results[2].search("//font").inner_html + ' :: ' +
            #position
      results[3].search("//font").inner_html + ' :: ' +
            #height
      results[4].search("//font").inner_html + ' :: ' +
            #weight
      results[5].search("//font").inner_html + ' :: ' +
            #year
      results[6].search("//font").inner_html.scan(/(.*)\s\(/)[0][0] + ' :: ' +
            #ht
      results[6].search("//font").inner_html.scan(/\s\((.*)\)/)[0][0]
            #school
end