xml.instruct!
xml.rss "version" => "2.0", "xmlns:dc" => "http://purl.org/dc/elements/1.1/" do
  xml.channel do
    xml.title "#{@season} Football Schedule"
    xml.link 'http://byufootballapp.com/'
    xml.pubDate Time.now
    xml.description h("BYU Football Schedule and Results")
	xml.media 'TV'
    @schedule.each do |game|
      if game.home_team_id == 43
        opponent = game.visitor_team_ap_rank.empty? ? game.visitor_team.to_s : '(' + game.visitor_team_ap_rank + ')' + game.visitor_team.to_s
        
        if game.complete?
          score = "#{game.home_score} - #{game.visitor_score}"
          result = game.home_score > game.visitor_score ? "W" : "L"
        else
          if game.tba?
            score = game.game_time.to_s(:day) + ' ' + 'TBA' unless game.game_time.nil?
          else
            score = game.game_time.to_s(:day) + ' ' + game.game_time.to_s(:time) unless game.game_time.nil?
          end
          result = " "
        end
      else
        opponent = game.home_team_ap_rank.empty? ? '@' + game.home_team.to_s : '@ (' + game.home_team_ap_rank + ')' + game.home_team.to_s
        
        if game.complete?
          score = "#{game.visitor_score} - #{game.home_score}"
          result = game.visitor_score > game.home_score ? "W" : "L"
        else
          if game.tba?
            score = game.game_time.to_s(:day) + ' ' + 'TBA' unless game.game_time.nil?
          else
            score = game.game_time.to_s(:day) + ' ' + game.game_time.to_s(:time) unless game.game_time.nil?
          end
          result = " "
        end
        
      end
	  media = game.media.empty? ? ' ' : game.media
      
	  xml.item do
        xml.title opponent
        xml.link score
        xml.description result
        xml.pubDate game.game_time
        xml.author media
      end
    end
  end
end