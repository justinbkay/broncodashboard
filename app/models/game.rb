class Game < ActiveRecord::Base
  attr_accessible :home_team_id, :visitor_team_id, :home_score, :visitor_score, :overtime, :game_time, :tba, :home_team_ap_rank, :visitor_team_ap_rank, :media, :website_id, :complete

  belongs_to :season
  belongs_to :home_team, :class_name => "Team", :foreign_key => "home_team_id"
  belongs_to :visitor_team, :class_name => "Team", :foreign_key => "visitor_team_id"
  belongs_to :stadium

  validates_presence_of :game_time, :on => :create, :message => "can't be blank"

  before_create :update_season

  # Store the current season here?
  SEASON = 9

  #def before_create
    #self.game_time = TimeZone['Mountain Time (US & Canada)'].local_to_utc(self.game_time)
  #end

  def update_season
    self.season_id = SEASON
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
    "<strong>#{visitor_team_ranked}</strong>" + ' &nbsp;at&nbsp; ' + "<strong>#{home_team_ranked}</strong>"
  end

  def schedule_view(team_id)
    if team_id == self.visitor_team_id
      "<strong>@#{home_team_ranked}</strong>"
    else
      "<strong>#{visitor_team_ranked}</strong>"
    end
  end

  def title
    "#{self.visitor_team.to_s} at #{self.home_team.to_s}"
  end

  def home_team_ranked
    home = self.home_team_ap_rank.empty? ? self.home_team.to_s : self.home_team.to_s + '(' + self.home_team_ap_rank + ')'
  end

  def visitor_team_ranked
    opponent = self.visitor_team_ap_rank.empty? ? self.visitor_team.to_s : self.visitor_team.to_s + '(' + self.visitor_team_ap_rank + ')'
  end

end
