class Team < ActiveRecord::Base
  belongs_to :conference
  belongs_to :stadium
  belongs_to :division
  
  def to_s
    name
  end
end
