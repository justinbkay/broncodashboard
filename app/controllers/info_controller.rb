class InfoController < ApplicationController
  def index
    @team = Team.find(1)
    @tz = get_tz
    @schedule = Game.find(:all, 
                          :conditions => 'home_team_id = 1 or visitor_team_id = 1 AND season_id=1',
                          :include => [:week], 
                          :order => 'game_time')
  end
  

  def change_tz
    session[:timezone] = params[:time_zone]
    index
    render :action => :index
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
  def get_tz
    session[:timezone] ||= 'Mountain Time (US & Canada)'
  end
end
