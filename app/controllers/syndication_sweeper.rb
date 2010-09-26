class SyndicationSweeper < ActionController::Caching::Sweeper
  observe Game
  
  def after_save(game)
    expire_caches_for(game)
  end
  
private
  def expire_caches_for(game)
    expire_page(:controller => :syndication, :action => :bsu_schedule_lite_plist)
    expire_page(:controller => :syndication, :action => :bsu_schedule_plist)
    expire_page(:controller => :syndication, :action => :roster_plist)
    expire_page(:controller => :syndication, :action => :vandal_roster_plist)
    expire_page(:controller => :syndication, :action => :bsu_schedule)
    expire_page(:controller => :syndication, :action => :vandal_schedule_plist)
    expire_page(:controller => :syndication, :action => :fresno_roster_plist)
    expire_page(:controller => :syndication, :action => :fresno_schedule_plist)
    expire_page(:controller => :syndication, :action => :hawaii_roster_plist)
    expire_page(:controller => :syndication, :action => :hawaii_schedule_plist)
    expire_page(:controller => :syndication, :action => :byu_schedule_plist)
    expire_page(:controller => :syndication, :action => :byu_roster_plist)
    expire_page(:controller => :syndication, :action => :byu_all_data)
    expire_page(:controller => :syndication, :action => :bsu_all_data)
    expire_page(:controller => :syndication, :action => :hawaii_all_data)
    expire_page(:controller => :syndication, :action => :vandal_all_data)
  end
end
