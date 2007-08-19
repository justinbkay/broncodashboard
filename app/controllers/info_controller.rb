class InfoController < ApplicationController
  caches_page :index
  def index
    @team = Team.find(1)
    @tz = get_tz
    @schedule = Game.find(:all, 
                          :conditions => 'home_team_id = 1 AND season_id=1 or visitor_team_id = 1 AND season_id=1',
                          :include => [:week], 
                          :order => 'game_time')
  end
  
  def get_schedule
    @team = Team.find(params[:id])
    @tz = get_tz
    @schedule = Game.find(:all, 
                          :conditions => ['home_team_id = ? AND season_id=1 or visitor_team_id = ? AND season_id=1',@team.id,@team.id],
                          :include => [:week], 
                          :order => 'game_time')
    render :layout => false
  end

  def change_tz
    session[:timezone] = params[:time_zone]
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
  
private 

end
