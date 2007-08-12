class Division < ActiveRecord::Base
  has_many :teams
  
  def to_s
    name
  end
  
  def self.for_select
    self.find(:all, :order => 'name').map {|d| [d.name, d.id]}
  end
end
