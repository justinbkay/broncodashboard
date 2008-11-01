require 'rubygems'    
require 'open-uri'
require 'hpricot'

class Scoreboard
  def self.write_partial
    # get espn data
    games = self.get_data
    
    path = File.expand_path RAILS_ROOT + '/app/views/info/_scoreboard.html.erb'
    fh = File.new(path,"w")
    fh.print "<h2>Interesting Games</h2>"
    fh.print "<p>"
    games.each do |game|
      fh.print '<table style="width: 250px;padding: 20px;">'
        fh.print "<tr style=\"background-color: #000;color: #fff;\"><td colspan='2'>#{game[0]}</td></tr>\n"
        fh.print "<tr><td style=\"width: 200px;\">#{game[1]}</td><td>#{game[3]}</td></tr>\n"
        fh.print "<tr class=\"odd\"><td>#{game[2]}</td><td>#{game[4]}</td></tr>\n"
      fh.print '</table>'
    fh.print '</p>'
      
    end
    
    fh.close
    
  end
  
  def self.get_data
    games = [];
    teams = ActiveRecord::Base.connection.select_all("SELECT distinct ht.espn_id as tid FROM games g inner join weeks w on g.week_id=w.id inner join teams ht on g.home_team_id=ht.id where w.season_id=#{Game::SEASON}").map {|h| h['tid']}

    teams += %w(38 9 30 265 252 254 204 68 278 62 70 2348 2440 166 23 328)
    
    aruba = Hpricot(open('http://scores.espn.go.com/ncf/scoreboard?confId=80&weekNumber=10&seasonYear=2008'))
    aruba.search("//div[@class='gameContainer']").each do |game|
      begin
        g = [];
        team_ids = [];

        #puts '-- Game --'
        g << game.search("//td[@class='teamTop']").inner_html
        game.search("//td[@class='teamLine']").each do |team|
          (team/"a").each do |e|
            # if the team id matches one of our id's we'll keep, otherwise discard
            team_ids << e.to_s.scan(/teamId=(\d+)/)[0][0]
            g << e.to_s.scan(/.*>(.*)<.*/)[0][0]
          end
        end

        unless team_ids.any? {|t| teams.include?(t)}
          raise
        end

        game.search("//td[@class='tScoreLine']").each do |score|
          g << score.inner_html
        end
        games << g
      rescue
        next
      end
    end
    return games
  end
  
end