# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base

private 
  def security
    unless session[:admin] == 1
      flash[:notice] = "Please Authenticate"
      redirect_to :controller => :login, :action => :login
    end
  end
  
  def get_tz
    session[:timezone] ||= 'Mountain Time (US & Canada)'
  end
end
