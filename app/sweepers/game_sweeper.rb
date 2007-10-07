class GameSweeper < ActionController::Caching::Sweeper
  observe Game # This sweeper is going to keep an eye on the Post model

  # If our sweeper detects that a Post was created call this
  def after_create(game)
          expire_cache_for(game)
  end
  
  # If our sweeper detects that a Post was updated call this
  def after_update(game)
          expire_cache_for(game)
  end
          
  private
  def expire_cache_for(record)
    # Expire the list page now that we posted a new blog entry
    expire_page(:controller => 'info', :action => 'index')
  end
end