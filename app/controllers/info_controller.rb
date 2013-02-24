class InfoController < ApplicationController
  caches_page :index

  before_filter :set_time_zone

  def set_time_zone
    Time.zone = session[:timezone] if session[:timezone]
  end

  def index
    @team = Team.find(1)
    @tz = get_tz
    @schedule = Game.where(['(home_team_id = 1 OR visitor_team_id = 1) AND season_id=?', Game::SEASON]).order(:game_time)

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
    @game = Game.where("(home_team_id = 1 OR visitor_team_id = 1) AND season_id = #{Game::SEASON} AND game_time > now()").order(:game_time)
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
    @schedule = Game.where(['(home_team_id = ? or visitor_team_id = ?) AND season_id=?',@team.id, @team.id, Game::SEASON]).order(:game_time)
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

  def iphone

  end

  def roster
    @players = Player.all(:conditions => 'team_id=1 and active=1')
  end

  def vandal_db
    render
  end

private

end
