class MoviesController < ApplicationController

	def movie_params
		params.require(:movie).permit(:title, :rating, :description, :release_date)
	end

	def show
		id = params[:id] # retrieve movie ID from URI route
		@movie = Movie.find(id) # look up movie by unique ID
		# will render app/views/movies/show.<extension> by default
	end

	def index
		@all_ratings = {:G => 1, :PG => 1, :PG-13 => 1, :R => 1}
		@filter = []
		should_redirect = false
		
		if params[:ratings] == nil
			if session[:filter] != nil
				session[:filter].each do |rate|
					@filter << rate
				end
				should_redirect = true 
			else
				@all_ratings.each do |rate|
					@filter << rate
				end
			end
		else
			params[:ratings].each do |rate|
				@filter << rate
			end
		end

		if session[:sort_by] == params[:sort_by] or params[:sort_by] == nil
			@sort_by => session[:sort_by]
			should_redirect = true
		else
			@sort_by = params[:sort_by]
		end

		if should_redirect
			redirect_to movies_path :ratings => @filter, :sort_by => @sort_by
			return
		end

		@checkerbox = []
		@filter.each do |filt|
			@checkerbox << filt[0]
		end

		if @sort_by == 'title'
			@movies = Movie.with_ratings(@filter).order(:title)
		elsif @sort_by == 'release_date'
			@movies = Movie.with_ratings(@filter).order(:release_date)
		else
			@movies = Movie.with_ratings(@filter)
		end

		session[:sort_by] = @sort_by
		session[:filter] = @filter
	end

	def new
		# default: render 'new' template
	end

	def create
		@movie = Movie.create!(movie_params)
		flash[:notice] = "#{@movie.title} was successfully created."
		redirect_to movies_path
	end

	def edit
		@movie = Movie.find params[:id]
	end

	def update
		@movie = Movie.find params[:id]
		@movie.update_attributes!(movie_params)
		flash[:notice] = "#{@movie.title} was successfully updated."
		redirect_to movie_path(@movie)
	end

	def destroy
		@movie = Movie.find(params[:id])
		@movie.destroy
		flash[:notice] = "Movie '#{@movie.title}' deleted."
		redirect_to movies_path
	end

end
