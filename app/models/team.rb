class Team < ActiveRecord::Base
  belongs_to :conference
  belongs_to :stadium
  
  def <=>(other)
    (self.home_wins + self.away_wins) <=> (other.home_wins + other.away_wins)
  end
  
  def self.for_select
    self.find(:all, :order => 'name').map {|t| [t.name, t.id]}
  end
  
  def home_wins
    Game.count(:conditions => ['home_team_id = ? AND s.id=? AND complete=1 AND home_score > visitor_score', self.id, Game::SEASON],
               :joins => 'as g inner join weeks w on g.week_id=w.id inner join seasons s on w.season_id=s.id')
  end
  
  def home_loses
    Game.count(:conditions => ['home_team_id = ? AND s.id=? AND complete=1 AND home_score < visitor_score', self.id, Game::SEASON],
               :joins => 'as g inner join weeks w on g.week_id=w.id inner join seasons s on w.season_id=s.id')
  end
  
  def away_loses
    Game.count(:conditions => ['visitor_team_id = ? AND s.id=? AND complete=1 AND home_score > visitor_score', self.id, Game::SEASON],
               :joins => 'as g inner join weeks w on g.week_id=w.id inner join seasons s on w.season_id=s.id')
  end
  
  def away_wins
    Game.count(:conditions => ['visitor_team_id = ? AND s.id=? AND complete=1 AND home_score < visitor_score', self.id, Game::SEASON],
               :joins => 'as g inner join weeks w on g.week_id=w.id inner join seasons s on w.season_id=s.id')
  end
  
  def conference_wins
    Game.count(:conditions => ['visitor_team_id=? and visitor_team.conference_id=home_team.conference_id and games.complete=1 and games.visitor_score > games.home_score AND s.id=?
  or home_team_id=? and home_team.conference_id=visitor_team.conference_id and games.complete=1 and games.home_score > games.visitor_score AND s.id=?', self.id, Game::SEASON, self.id, Game::SEASON],
               :joins => 'inner join teams home_team on games.home_team_id=home_team.id 
               inner join teams visitor_team on visitor_team.id=games.visitor_team_id inner join weeks w on w.id=games.week_id inner join seasons s on s.id=w.season_id')
  end
  
  def conference_loses
    Game.count(:conditions => ['visitor_team_id=? and visitor_team.conference_id=home_team.conference_id and games.complete=1 and games.visitor_score < games.home_score AND s.id=?
  or home_team_id=? and home_team.conference_id=visitor_team.conference_id and games.complete=1 and games.home_score < games.visitor_score AND s.id=?', self.id, Game::SEASON, self.id, Game::SEASON],
               :joins => 'inner join teams home_team on games.home_team_id=home_team.id 
               inner join teams visitor_team on visitor_team.id=games.visitor_team_id inner join weeks w on w.id=games.week_id inner join seasons s on s.id=w.season_id')
  end
  
  def ranked_wins
    Game.count(:conditions => ['visitor_team_id=? and games.home_team_ap_rank > 0 and games.complete=1 and games.visitor_score > games.home_score AND seasons.id=?
  OR home_team_id=? and games.visitor_team_ap_rank > 0  and games.complete=1 and games.home_score > games.visitor_score AND seasons.id=?', self.id, Game::SEASON,self.id,Game::SEASON],
               :include => {:week => :season})
  end
  
  def ranked_loses
    Game.count(:conditions => ['visitor_team_id=? and games.home_team_ap_rank > 0 and games.complete=1 and games.visitor_score < games.home_score AND seasons.id=?
  OR home_team_id=? and games.visitor_team_ap_rank > 0 and games.complete=1 and games.home_score < games.visitor_score AND seasons.id=?', self.id, Game::SEASON,self.id,Game::SEASON],
               :include => {:week => :season})
    
  end
  
  def home_score_total
    Game.sum('home_score', :conditions => ['home_team_id=? and complete=1 AND season_id=?',self.id,Game::SEASON], :include => {:week => :season}) || 0
  end
  
  def visitor_score_total
    Game.sum('visitor_score', :conditions => ['visitor_team_id = ? AND complete=1 AND season_id=?', self.id,Game::SEASON], :include => {:week => :season}) || 0
  end
  
  def game_count
    Game.count(:conditions => ['home_team_id=? AND complete=1 AND season_id=? OR visitor_team_id=? AND complete=1 AND season_id=?',self.id,Game::SEASON,self.id,Game::SEASON], :include => {:week => :season})
  end
  
  def home_points_allowed
    Game.sum('visitor_score', :conditions => ['home_team_id=? and complete=1 AND season_id=?',self.id,Game::SEASON], :include => {:week => :season}) || 0
  end
  
  def visitor_points_allowed
    Game.sum('home_score', :conditions => ['visitor_team_id=? and complete=1 AND season_id=?',self.id, Game::SEASON], :include => {:week => :season}) || 0
  end
  
  def home_pass_allowed
    Game.sum('visitor_passing_yards', :conditions => ['home_team_id = ? AND season_id=? AND complete=1', self.id, Game::SEASON], :include => {:week => :season})
  end
  
  def visitor_pass_allowed
    Game.sum('home_passing_yards', :conditions => ['visitor_team_id = ? AND season_id=? AND complete=1', self.id, Game::SEASON], :include => {:week => :season})
  end

  def home_rush_allowed
    Game.sum('visitor_rushing_yards', :conditions => ['home_team_id = ? AND season_id=? AND complete=1', self.id, Game::SEASON], :include => {:week => :season})
  end
  
  def visitor_rush_allowed
    Game.sum('home_rushing_yards', :conditions => ['visitor_team_id = ? AND season_id=? AND complete=1', self.id, Game::SEASON], :include => {:week => :season})
  end
  
  def home_pass
    Game.sum('home_passing_yards', :conditions => ['home_team_id = ? AND season_id=? AND complete=1', self.id, Game::SEASON], :include => {:week => :season})
  end
  
  def visitor_pass
    Game.sum('visitor_passing_yards', :conditions => ['visitor_team_id = ? AND season_id=? AND complete=1', self.id, Game::SEASON], :include => {:week => :season})
  end

  def home_rush
    Game.sum('home_rushing_yards', :conditions => ['home_team_id = ? AND season_id=? AND complete=1', self.id, Game::SEASON], :include => {:week => :season})
  end
  
  def visitor_rush
    Game.sum('visitor_rushing_yards', :conditions => ['visitor_team_id = ? AND season_id=? AND complete=1', self.id, Game::SEASON], :include => {:week => :season})
  end
  
  def avg_attendance
    total = Game.sum('attendance', :conditions => ['home_team_id = ? AND season_id=? AND complete=1', self.id, Game::SEASON], :include => {:week => :season})
    count = Game.count(:conditions => ['home_team_id = ? AND season_id=? AND complete=1', self.id, Game::SEASON], :include => {:week => :season})
    number_with_delimiter(total / count, ',')
  rescue 
    0
  end
  
  def avg_rush
    (home_rush + visitor_rush) / game_count.to_f
  end
  
  def avg_pass
    (home_pass + visitor_pass) / game_count.to_f
  end
 
  def avg_total_yards
    avg_pass + avg_rush
  end
 
  def avg_pass_allowed
    (home_pass_allowed + visitor_pass_allowed) / game_count.to_f
  end
  
  def avg_rush_allowed
    (home_rush_allowed + visitor_rush_allowed) / game_count.to_f
  end
  
  def avg_yards_allowed
    avg_pass_allowed + avg_rush_allowed
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
  
  def wins
    home_wins + away_wins
  end
  
  def loses
    home_loses + away_loses
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
