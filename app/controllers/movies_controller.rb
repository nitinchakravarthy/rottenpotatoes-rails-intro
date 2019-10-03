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
    if (params[:sort].nil?)
     params[:sort] = session[:sort] || {}
    end
    
    if (params[:ratings].nil?)
      params[:ratings] = session[:ratings] || {}
    end
    
    #puts("inside index")
    @all_ratings = Movie.distinct.pluck(:rating)
    @ratings = params[:ratings] || {}  # if ratings are not passed
    #puts("ratings: " + @ratings.to_s())
    
    if params[:sort] == "title" 
      @movies = Movie.with_ratings(@ratings).order(:title)
    elsif params[:sort] == "date"
      @movies = Movie.with_ratings(@ratings).order(:release_date)
    else
      @movies = Movie.with_ratings(@ratings)
    end
    
    #puts("the ratings are: " + @ratings.to_s())
    # put settings in session
     session[:sort] = params[:sort]
     session[:ratings] = params[:ratings]
     puts(session[:ratings])
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
