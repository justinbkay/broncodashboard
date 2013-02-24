require 'rubygems'
require 'open-uri'
require 'hpricot'

class Scoreboard
  def self.write_partial
    # get espn data
    games = self.get_data

    path = File.expand_path(Rails.root) + '/app/views/info/_scoreboard.html.erb'
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

  def self.update_polls
    ap = []
    coaches = []
    bcs = []

    {"1" => ap,"2" => coaches, "999" => bcs}.each_pair do |key, value|
      aruba = Hpricot(open("http://m.espn.go.com/ncf/rankings?week=0&pollId=#{key}&wjb"))
      aruba.search("//table/tr").each do |game|

        results = game.search("//td")
        if results[0].inner_html =~ /\d/
          value << {'rank' => results[0].inner_html, 'team' => results[1].search("//a").inner_html}
        end
      end
    end
    polls = {'ap' => ap, 'coaches' => coaches, 'bcs' => bcs}

    polls.each_pair do |key, p|
      if p.empty?
        polls[key] = [{"rank"=>"1", "team"=>" "}, {"rank"=>"2", "team"=>" "}, {"rank"=>"3", "team"=>" "}, {"rank"=>"4", "team"=>" "}, {"rank"=>"5", "team"=>" "}, {"rank"=>"6", "team"=>" "}, {"rank"=>"7", "team"=>" "}, {"rank"=>"8", "team"=>" "}, {"rank"=>"9", "team"=>" "}, {"rank"=>"10", "team"=>" "}, {"rank"=>"11", "team"=>" "}, {"rank"=>"12", "team"=>" "}, {"rank"=>"13", "team"=>" "}, {"rank"=>"14", "team"=>" "}, {"rank"=>"15", "team"=>" "}, {"rank"=>"16", "team"=>" "}, {"rank"=>"17", "team"=>" "}, {"rank"=>"18", "team"=>" "}, {"rank"=>"19", "team"=>" "}, {"rank"=>"20", "team"=>" "}, {"rank"=>"21", "team"=>" "}, {"rank"=>"22", "team"=>" "}, {"rank"=>"23", "team"=>" "}, {"rank"=>"24", "team"=>" "}, {"rank"=>"25", "team"=>" "}]
      end
    end

    path = File.expand_path(Rails.root) + '/public/polls_dump'
    fh = File.new(path,"w")
    fh << Marshal.dump(polls)
    #fh.print Plist::Emit.dump(polls)
    fh.close

    #old polls
    plist_path = File.expand_path(Rails.root) + '/public/polls_plist'
    f = File.new(plist_path,"w")
    f.print Plist::Emit.dump(Marshal.load(File.read(path)))
    f.close

  end

  def self.get_data
    games = [];
    teams = ActiveRecord::Base.connection.select_all("SELECT distinct ht.espn_id as tid FROM games g inner join teams ht on g.home_team_id=ht.id where season_id=#{Game::SEASON}").map {|h| h['tid']}

    teams += %w(38 9 30 265 252 254 204 68 278 62 70 2348 2440 166 23 328)

    aruba = Hpricot(open('http://scores.espn.go.com/ncf/scoreboard?confId=80&weekNumber=13&seasonYear=2008'))
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
