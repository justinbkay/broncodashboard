xml.instruct!
xml.rss "version" => "2.0", "xmlns:dc" => "http://purl.org/dc/elements/1.1/" do
  xml.channel do
    xml.title 'Boise State Schedule'
    xml.link 'http://broncodashboard.com/'
    xml.pubDate Time.now
    xml.description h("Boise State 2007-08 Football Schedule and Results")
    @schedule.each do |game|
      if game.home_team_id == 1
        opponent = game.visitor_team.to_s
        if game.complete?
          score = "#{game.home_score} - #{game.visitor_score}"
          result = game.home_score > game.visitor_score ? "W" : "L"
        else
          score = TimeZone[@tz].utc_to_local(game.game_time).to_s(:day) + ' ' + TimeZone[@tz].utc_to_local(game.game_time).to_s(:time) unless game.game_time.nil?
          result = " "
        end
      else
        opponent = game.home_team.to_s
        if game.complete?
          score = "#{game.visitor_score} - #{game.home_score}"
          result = game.visitor_score > game.home_score ? "W" : "L"
        else
          score = score = TimeZone[@tz].utc_to_local(game.game_time).to_s(:day) + ' ' + TimeZone[@tz].utc_to_local(game.game_time).to_s(:time) unless game.game_time.nil?
          result = " "
        end
        
      end
      xml.item do
        #xml.title TimeZone[@tz].utc_to_local(game.game_time).to_s(:day) + ' ' + TimeZone[@tz].utc_to_local(game.game_time).to_s(:time) + ' ' + game.title
        xml.title opponent
        xml.link score
        xml.description result
        #xml.link 'http://broncodashboard.com/'
        #xml.description "#{game.home_team} #{game.home_score} - #{game.visitor_team} #{game.visitor_score} -- #{game.stadium}"
        xml.pubDate game.game_time
        xml.author 'jbk'
      end
    end
  end
end