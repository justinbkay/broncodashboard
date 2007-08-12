class AdminController < ApplicationController
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
