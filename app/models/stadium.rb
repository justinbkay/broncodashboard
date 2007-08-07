class Stadium < ActiveRecord::Base
  has_one :team
  has_many :games
  
  def to_s
    name
  end
end
