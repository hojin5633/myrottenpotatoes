class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def create
    params.require(:movie)
    permitted=params[:movie].permit(:title,:rating,:release_date)
    
    @movie = Movie.create!(permitted)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = ['G','PG','PG-13','R']
    session[:order] = params[:order] unless params[:order].nil?
    session[:ratings] = params[:ratings] unless params[:ratings].nil?
#    session[:ratings] = {} if params[:ratings].nil?
#    @ratings = session[:ratings] unless session[:ratings].nil?
    ratings = session[:ratings]
    movies = Movie.all
    if ratings.any?
      movies = movies.where(:rating => ratings.keys)
    end
    movies = movies.all.sort_by{|m| m.title} if session[:order] == "title"
    movies = movies.all.sort_by{|m| m.release_date}.reverse if session[:order] == "release_date"
    
    @movies = movies
  end

  def new
    @movie = Movie.new
  end 

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    permitted = params[:movie].permit(:title,:rating,:release_date)
    @movie.update_attributes!(permitted)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end
  
  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#[@movie.title}' deleted."
    redirect_to movies_path
  end
  
  def search_tmdb
    # hardwire to simulate failure
    flash[:warning] = "'#{params[:search_terms]}' was not found in TMDb."
    redirect_to movies_path
  end
  
  def hilight(column)
    if(session[:order] == column)
      return 'hilite'
    else
      return nil
    end
  end
end