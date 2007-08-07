class InfoController < ApplicationController
  def index
    @team = Team.find(1)
    @tz = get_tz
    @schedule = Game.find(:all, :conditions => 'home_team_id = 1 or visitor_team_id = 1', :order => 'game_time')
  end
  

  def change_tz
    session[:timezone] = params[:time_zone]
    index
    render :action => :index
  end
  
private 
  def get_tz
    session[:timezone] ||= 'Mountain Time (US & Canada)'
  end
end
