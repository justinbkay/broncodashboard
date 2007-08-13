class Season < ActiveRecord::Base
  has_many :weeks
  
  def to_s
    name
  end
end
