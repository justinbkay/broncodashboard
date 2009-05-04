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
  
end
