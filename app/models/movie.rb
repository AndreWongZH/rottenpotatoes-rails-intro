class Movie < ActiveRecord::Base
	def self.with_ratings(ratings)
		removed_arr = []
		ratings.each do |rate|
			removed_arr << rate[0]
		end

		return Movie.where(rating: removed_arr)
	end
end
