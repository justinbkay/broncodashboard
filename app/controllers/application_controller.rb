class ApplicationController < ActionController::Base
  protect_from_forgery

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
