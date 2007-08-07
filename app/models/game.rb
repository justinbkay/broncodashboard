class Game < ActiveRecord::Base
  belongs_to :week
  belongs_to :home_team, :class_name => "Team", :foreign_key => "home_team_id"
  belongs_to :visitor_team, :class_name => "Team", :foreign_key => "visitor_team_id"
  belongs_to :stadium
  
  
  def to_s
    "<strong>#{self.visitor_team.to_s}</strong>" + ' &nbsp;at&nbsp; ' + "<strong>#{self.home_team.to_s}</strong>"  
  end
end
