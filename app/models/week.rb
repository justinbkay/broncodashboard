class Week < ActiveRecord::Base
  belongs_to :season
  has_many :games
  
  def self.for_select
    self.find(:all, :order => "week_order").map {|w| [w.name + ' ' + w.season.to_s, w.id]}
  end
end
