class Movie < ActiveRecord::Base
  validates :title, :presence => true
  validates :release_date, :presence => true
  validates :rating, :inclusion => {:in => Movie.all_ratings},
    :unless => :grandfathered?
  validate :released_1930_or_later # uses custom validator below
  def released_1930_or_later
    errors.add(:release_date, 'must be 1930 or later') if
      release_date && release_date < Date.parse('1 Jan 1930')
  end
  @@grandfathered_date = Date.parse('1 Nov 1968')
  def grandfathered?
    release_date && release_date < @@grandfathered_date
  end
end