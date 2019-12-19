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
		@all_ratings = ['G', 'PG', 'PG-13', 'R']
		@filter = []
		
		if params[:ratings] == nil
			if session[:filter] != nil
				redirect_to movies_path :ratings => session[:filter]
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
			redirect_to movies_path :sort_by => session[:sort_by]
		else
			@sort_by = params[:sort_by]
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
