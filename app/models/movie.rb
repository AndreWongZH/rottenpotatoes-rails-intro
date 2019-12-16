class Movie < ActiveRecord::Base
	def with_ratings(rating)
		return Movie.where(ratings: rating)
	end
end
