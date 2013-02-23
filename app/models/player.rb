class Player < ActiveRecord::Base
  scope :active, lambda { where(:active => true).order(:number) }
  belongs_to :team

  def name
    self.first_name + ' ' + self.last_name
  end

  def last_first
    self.last_name + ', ' + self.first_name
  end

  alias to_s name
end
