class Team < ActiveRecord::Base
  belongs_to :conference
  belongs_to :stadium
  
  def self.for_select
    self.find(:all, :order => 'name').map {|t| [t.name, t.id]}
  end
  
  def home_wins
    Game.count(:conditions => ['home_team_id = ? AND s.id=1 AND complete=1 AND home_score > visitor_score', self.id],
               :joins => 'as g inner join weeks w on g.week_id=w.id inner join seasons s on w.season_id=s.id')
  end
  
  def home_loses
    Game.count(:conditions => ['home_team_id = ? AND s.id=1 AND complete=1 AND home_score < visitor_score', self.id],
               :joins => 'as g inner join weeks w on g.week_id=w.id inner join seasons s on w.season_id=s.id')
  end
  
  def away_loses
    Game.count(:conditions => ['visitor_team_id = ? AND s.id=1 AND complete=1 AND home_score > visitor_score', self.id],
               :joins => 'as g inner join weeks w on g.week_id=w.id inner join seasons s on w.season_id=s.id')
  end
  
  def away_wins
    Game.count(:conditions => ['visitor_team_id = ? AND s.id=1 AND complete=1 AND home_score < visitor_score', self.id],
               :joins => 'as g inner join weeks w on g.week_id=w.id inner join seasons s on w.season_id=s.id')
  end
  
  def conference_wins
    Game.count(:conditions => ['visitor_team_id=? and visitor_team.conference_id=home_team.conference_id and games.complete=1 and games.visitor_score > games.home_score
  or home_team_id=? and home_team.conference_id=visitor_team.conference_id and games.complete=1 and games.home_score > games.visitor_score', self.id, self.id],
               :joins => 'inner join teams home_team on games.home_team_id=home_team.id 
               inner join teams visitor_team on visitor_team.id=games.visitor_team_id')
  end
  
  def conference_loses
    Game.count(:conditions => ['visitor_team_id=? and visitor_team.conference_id=home_team.conference_id and games.complete=1 and games.visitor_score < games.home_score
  or home_team_id=? and home_team.conference_id=visitor_team.conference_id and games.complete=1 and games.home_score < games.visitor_score', self.id, self.id],
               :joins => 'inner join teams home_team on games.home_team_id=home_team.id 
               inner join teams visitor_team on visitor_team.id=games.visitor_team_id')
  end
  
  def ranked_wins
    Game.count(:conditions => ['visitor_team_id=? and games.home_team_ap_rank > 0 and games.complete=1 and games.visitor_score > games.home_score
  OR home_team_id=? and games.visitor_team_ap_rank > 0  and games.complete=1 and games.home_score > games.visitor_score', self.id, self.id])
  end
  
  def ranked_loses
    Game.count(:conditions => ['visitor_team_id=? and games.home_team_ap_rank > 0 and games.complete=1 and games.visitor_score < games.home_score
  OR home_team_id=? and games.visitor_team_ap_rank > 0 and games.complete=1 and games.home_score < games.visitor_score', self.id, self.id])
    
  end
  
  def home_score_total
    Game.sum('home_score', :conditions => ['home_team_id=? and complete=1',self.id]) || 0
  end
  
  def visitor_score_total
    Game.sum('visitor_score', :conditions => ['visitor_team_id = ? AND complete=1', self.id]) || 0
  end
  
  def game_count
    Game.count(:conditions => ['home_team_id=? AND complete=1 OR visitor_team_id=? AND complete=1',self.id,self.id])
  end
  
  def home_points_allowed
    Game.sum('visitor_score', :conditions => ['home_team_id=? and complete=1',self.id]) || 0
  end
  
  def visitor_points_allowed
    Game.sum('home_score', :conditions => ['visitor_team_id=? and complete=1',self.id]) || 0
  end
  
  def average_allowed
    (home_points_allowed + visitor_points_allowed) / game_count.to_f
  end
  
  def average_score
    (home_score_total + visitor_score_total) / game_count.to_f
  end
  
  def ranked_record
    "#{ranked_wins} - #{ranked_loses}"
  end
  
  def conference_record
    "#{conference_wins} - #{conference_loses}"
  end
  
  def record
    "#{home_wins + away_wins} - #{home_loses + away_loses}"
  end
  
  def home_record
    "#{home_wins} - #{home_loses}"
  end
  
  def away_record
    "#{away_wins} - #{away_loses}"
  end
  
  def to_s
    name
  end
end
