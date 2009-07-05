class Player < ActiveRecord::Base

  named_scope :active, :conditions => {:active => true}
  
  def name
    self.first_name + ' ' + self.last_name
  end
end
