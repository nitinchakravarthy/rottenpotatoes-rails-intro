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
    puts("inside index")
    @all_ratings = ['G','PG','PG-13','R']
    @ratings = params[:ratings] ||{}
    puts("ratings: " + @ratings.to_s())
    if params[:sort] == "title" 
      @movies = Movie.with_ratings(@ratings).order(:title)
    elsif params[:sort] == "date"
      @movies = Movie.with_ratings(@ratings).order(:release_date)
    else
      @movies = Movie.with_ratings(@ratings)
    end
    puts("the ratings are: " + @ratings.to_s())
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
  
  # def title_sort
  #   puts("reached title_sort")
  #   @movies = (Movie.all).sort_by {|movie| movie.title}
  #   puts(@movies[0].title)
  #   render :action => 'index'
  # end
  
  # def releasedate_sort
  #   puts("reached releasedate sort")
  #   @movies = (Movie.all).sort_by {|movie| movie.release_date}
  #   puts(@movies[0].title)
  #   render :action => 'index'
  # end
  

end
