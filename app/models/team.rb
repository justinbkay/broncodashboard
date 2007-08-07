class Team < ActiveRecord::Base
  belongs_to :conference
  belongs_to :stadium
  belongs_to :division
  
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
