class Review < ActiveRecord::Base
  belongs_to :movie
  belongs_to :moviegoer
  
  #figure 5.18
  validates :movie_id, :presence =>true
  validates_associated :movie
  
end
