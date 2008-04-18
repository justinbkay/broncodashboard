class SyndicationController < ApplicationController
  session :off
  
  def bsu_schedule
    @team = Team.find(1)
    @tz = get_tz
    @schedule = Game.find(:all, 
                          :conditions => ['home_team_id = 1 AND season_id=? or visitor_team_id = 1 AND season_id=?',Game::SEASON,Game::SEASON],
                          :include => [:week], 
                          :order => 'game_time')
    @headers["Content-Type"] = "application/rss+xml"
  end
end
