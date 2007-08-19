class Game < ActiveRecord::Base
  belongs_to :week
  belongs_to :home_team, :class_name => "Team", :foreign_key => "home_team_id"
  belongs_to :visitor_team, :class_name => "Team", :foreign_key => "visitor_team_id"
  belongs_to :stadium
  
  def before_create
    self.game_time = TimeZone['Mountain Time (US & Canada)'].local_to_utc(self.game_time)
  end
  
  def mountain_time
    if self.game_time.nil?
      nil
    else
      TimeZone['Mountain Time (US & Canada)'].utc_to_local(self.game_time)
    end
  end
  
  def mountain_time=(value)
    self[:game_time] = TimeZone['Mountain Time (US & Canada)'].local_to_utc(value)
  end
  
  def to_s
    "<strong>#{self.visitor_team.to_s}</strong>" + ' &nbsp;at&nbsp; ' + "<strong>#{self.home_team.to_s}</strong>"  
  end
  
  def title
    "#{self.visitor_team.to_s} at #{self.home_team.to_s}"
  end
  
end
