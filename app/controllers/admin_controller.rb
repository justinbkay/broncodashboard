class AdminController < ApplicationController
  cache_sweeper :game_sweeper, :only => [:create_game, :update_game]
  before_filter :security
  cache_sweeper :syndication_sweeper

  def index
    redirect_to :action => 'list_teams'
  end

  def list_games
    if params[:all]
      @games = Game.where(:season_id => Game::SEASON).order(:game_time)
    else
      @games = Game.where(:season_id => Game::SEASON, :complete => false).order(:game_time)
    end
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
      render :action => :new_game
    end
  rescue ActiveRecord::StatementInvalid
    flash[:error] = "That game was already entered"
    render :action => :new_game
  end

  def update_game
    @game = Game.find(params[:id])
    #@game.mountain_time = DateTime.civil(params[:game]['mountain_time(1i)'].to_i,params[:game]['mountain_time(2i)'].to_i,params[:game]['mountain_time(3i)'].to_i,params[:game]['mountain_time(4i)'].to_i,params[:game]['mountain_time(5i)'].to_i)
    if @game.update_attributes(params[:game])
      flash[:notice] = "Game Updated"
      redirect_to :action => :list_games
    else
      render :action => :edit_game
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
      render :action => :new_team
    end
  end

  def update_team
    @team = Team.find(params[:id])
    if @team.update_attributes(params[:team])
      flash[:notice] = "Team Updated"
      redirect_to :action => :list_teams
    else
      render :action => :edit_team
    end
  end
end
