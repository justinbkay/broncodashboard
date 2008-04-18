class AdminController < ApplicationController
  cache_sweeper :game_sweeper, :only => [:create_game, :update_game]
  before_filter :security
  
  def index
    redirect_to :action => 'list_teams'
  end
  
  def list_games
    @games = Game.find(:all, :conditions => ['season_id = ?', Game::SEASON], :include => 'week', :order => 'game_time')
  end
  
  def edit_game
    @game = Game.find(params[:id])
  end
  
  def new_game
    @game = Game.new
  end
  
  def create_game
    @game = Game.new(params[:game])
    if @game.save
      flash[:notice] = "Game Created"
      redirect_to :action => :list_games
    else
      render :new_game
    end
  end
  
  def update_game
    @game = Game.find(params[:id])
    #@game.mountain_time = DateTime.civil(params[:game]['mountain_time(1i)'].to_i,params[:game]['mountain_time(2i)'].to_i,params[:game]['mountain_time(3i)'].to_i,params[:game]['mountain_time(4i)'].to_i,params[:game]['mountain_time(5i)'].to_i)
    if @game.update_attributes(params[:game])
      flash[:notice] = "Game Updated"
      redirect_to :action => :list_games
    else
      render :edit_game
    end
  end
  
  def list_teams
    @teams = Team.find(:all, :order => 'name')
  end
  
  def edit_team
    @team = Team.find(params[:id])
  end
  
  def new_team
    @team = Team.new
  end
  
  def create_team
    @team = Team.new(params[:team])
    if @team.save
      flash[:notice] = "Team Created"
      redirect_to :action => :list_teams
    else
      render :new_team
    end
  end
  
  def update_team
    @team = Team.find(params[:id])
    if @team.update_attributes(params[:team])
      flash[:notice] = "Team Updated"
      redirect_to :action => :list_teams
    else
      render :edit_team
    end
  end
end
