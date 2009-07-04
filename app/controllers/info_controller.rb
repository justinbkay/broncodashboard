class InfoController < ApplicationController
  caches_page :index
  
  def index
    @team = Team.find(1)
    @tz = get_tz
    @schedule = Game.find(:all, 
                          :conditions => ['home_team_id = 1 AND weeks.season_id=? or visitor_team_id = 1 AND weeks.season_id=?',Game::SEASON,Game::SEASON],
                          :include => [:week], 
                          :order => 'game_time')

    @opponents = []
    @opponent_wins = 0
    @opponent_loses = 0
    
    @schedule.each do |g|
      if g.home_team_id == 1
        @opponent_wins += g.visitor_team.wins
        @opponent_loses += g.visitor_team.loses
        @opponents << g.visitor_team
      else
        @opponent_wins += g.home_team.wins
        @opponent_loses += g.home_team.loses
        @opponents << g.home_team
      end
    end
    
    # get the deets
    @game = Game.find(:first, 
                      :conditions => "home_team_id = 1 AND weeks.season_id=#{Game::SEASON} AND game_time > now() or visitor_team_id = 1 AND weeks.season_id=#{Game::SEASON} AND game_time > now()",
                      :include => [:week],
                      :order => 'game_time')
        
    unless @game.nil?                  
      if @game.home_team_id == 1
        @bsu = @game.home_team
        @visitor = @game.visitor_team
      else
        @bsu = @game.visitor_team
        @visitor = @game.home_team
      end
    end
  end
  
  def get_schedule
    @team = Team.find(params[:id])
    @tz = get_tz
    @schedule = Game.find(:all, 
                          :conditions => ['home_team_id = ? AND weeks.season_id=? or visitor_team_id = ? AND weeks.season_id=?',@team.id,Game::SEASON,@team.id,Game::SEASON],
                          :include => [:week], 
                          :order => 'game_time')
    render :layout => false
  end

  def change_tz
    Time.zone = params[:time_zone] #session[:timezone] = params[:time_zone]
    redirect_to :action => :index
  end
  
  def fetch_details
    @game = Game.find(params[:id])
    if @game.home_team_id == 1
      @bsu = @game.home_team
      @visitor = @game.visitor_team
    else
      @bsu = @game.visitor_team
      @visitor = @game.home_team
    end
    
    render :partial => 'details'
  end
  
  def wac
    bow = Date.today.beginning_of_week
    eow = bow + 7
    @tz = get_tz
    @teams = Team.find(:all, :conditions => 'conference_id=12').sort! {|x,y| y <=> x}
    @this_week = Game.find(:all, 
                           :conditions => ['game_time BETWEEN ? AND ? AND visitor_teams_games.conference_id=12 OR game_time BETWEEN ? AND ? AND teams.conference_id=12', bow, eow, bow, eow], :order => 'game_time', 
                           :include => ['home_team','visitor_team'])
  end

  def scoreboard
    render
    
  end
  
private 

end
