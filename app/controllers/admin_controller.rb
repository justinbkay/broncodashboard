class AdminController < ApplicationController
  before_filter :security
  
  def index
    list_teams
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
