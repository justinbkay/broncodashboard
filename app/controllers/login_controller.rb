class LoginController < ApplicationController

  def login
    if request.post?
      if params[:username] == 'jbk' && params[:secret] == 'thebroncosthebroncosthemightymightybroncos'
        session[:admin] = 1
        redirect_to :controller => :admin, :action => :list_teams
      else
        flash[:notice] = "Invalid Credentials"
      end
    end
  end
  
  def logout
    session[:admin] = nil
    flash[:notice] = "Logged Out"
    redirect_to :controller => :login, :action => :login
  end
end
