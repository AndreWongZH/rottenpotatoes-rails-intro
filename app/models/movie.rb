class Movie < ActiveRecord::Base
	def self.with_ratings(rating)
		return Movie.where(ratings: rating)
	end
end
