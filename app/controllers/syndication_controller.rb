class SyndicationController < ApplicationController
  session :off
  
  def bsu_schedule
    @team = Team.find(1)
    @tz = get_tz
    @season = Season.find(Game::SEASON)
    @schedule = Game.find(:all, 
                          :conditions => ['home_team_id=1 AND weeks.season_id=? OR visitor_team_id=1 AND weeks.season_id=?',Game::SEASON,Game::SEASON], 
                          :include => 'week',
                          :order => 'game_time')
            
    #@headers["Content-Type"] = "application/rss+xml"
    respond_to do |format|
      format.xml
    end
  end
  
  def roster
    @players = Player.active
    
    respond_to do |format|
      format.xml
    end
    
  end
  
  def bsu_schedule_plist
    @schedule = Game.find(:all, 
                          :conditions => ['home_team_id=1 AND weeks.season_id=? OR visitor_team_id=1 AND weeks.season_id=?',Game::SEASON,Game::SEASON], 
                          :include => 'week',
                          :order => 'game_time')
    plist_array = []
    @schedule.each do |game|
      if game.home_team_id == 1
        opponent = game.visitor_team_ranked
        
        if game.visitor_team.conference_id == 12
          opponent += '*'
        end
        
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
        opponent = "@" + game.home_team_ranked
        
        if game.home_team.conference_id == 12
          opponent += '*'
        end
        
        if game.complete?
          score = "#{game.visitor_score} - #{game.home_score}"
          result = game.visitor_score > game.home_score ? "W" : "L"
        else
          if game.tba?
            score =  game.game_time.to_s(:day) + ' ' + 'TBA' unless game.game_time.nil?
          else
            score = game.game_time.to_s(:day) + ' ' + game.game_time.to_s(:time) unless game.game_time.nil?
          end
          result = " "
        end
        
      end
	  media = game.media.empty? ? ' ' : game.media
      
      
      plist_array << {'date' => score, 'opponent' => opponent, 'tv' => media, 'result' => result}
    end
    
    plist = Plist::Emit.dump(plist_array)
    render(:text => plist)
    
  end
  
  def roster_plist
    @players = Player.active
    plist_hash = []
    
    @players.each do |p|
      plist_hash << {'number' => p.number, 
                     'name' => p.name, 
                     'position' => p.position, 
                     'year' => p.year,
                     'height' => p.height,
                     'weight' => p.weight,
                     'hometown' => p.hometown,
                     'previous_school' => p.previous_school}
    end
    
    plist = Plist::Emit.dump(plist_hash)
    render(:text => plist)
  end
  
end
