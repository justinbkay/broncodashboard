class Stadium < ActiveRecord::Base
  has_one :team
  has_many :games
  
  def self.for_select
    self.find(:all, :order => 'name').map {|s| [s.name + ' -- ' + s.city + ', ' + s.state, s.id]}
  end
  
  def to_s
    name
  end
end
