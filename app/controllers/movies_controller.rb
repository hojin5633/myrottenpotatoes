class MoviesController < ApplicationController
  def movies_with_filters
    @movies = @movies.for_kids          if params[:for_kids]
    @movies = @movies.with_good_reviews   if params[:with_good_reviews]
    @movies = @movies.recently_reviewed(4) if params[:recently_reviewed]
  end

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end
=begin
  def create
    params.require(:movie)
    permitted=params[:movie].permit(:title,:rating,:release_date)
    
    @movie = Movie.create!(permitted)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end
=end
  def create
    params.require(:movie)
    permitted=params[:movie].permit(:title,:rating,:release_date)
    @movie = Movie.new(permitted)
    if @movie.save
      flash[:notice] = "#{@movie.title} was successfully created."
      redirect_to movies_path
    else
      render 'new' # note, 'new' template can access @movie's field values!
    end
  end
  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = ['G','PG','PG-13','R', 'NC-17']
    session[:order] = params[:order] unless params[:order].nil?
    session[:ratings] = params[:ratings] unless params[:ratings].nil?
#    session[:ratings] = {} if params[:ratings].nil?
    ratings = session[:ratings]
    if ratings.nil?
      temp = Hash.new
      @all_ratings.each do |n|
        temp[n] = 1
      end
      session[:ratings] = temp
      ratings = session[:ratings]
    end
    order = session[:order]
    @movies = Movie.all
    if params[:for_kids] || params[:with_good_reviews] || params[:recently_reviewed]
      movies_with_filters
    end
    movies = @movies
    movies = movies.where(:rating => ratings.keys)
    movies = movies.all.sort_by{|m| m.title} if order == "title"
    movies = movies.all.sort_by{|m| m.release_date}.reverse if order == "release_date"
    
    
    @movies = movies
  end
  def new
    @movie = Movie.new
  end 

  def edit
    @movie = Movie.find params[:id]
  end
=begin
  def update
    @movie = Movie.find params[:id]
    permitted = params[:movie].permit(:title,:rating,:release_date)
    @movie.update_attributes!(permitted)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end
=end
  def update
    @movie = Movie.find params[:id]
    permitted = params[:movie].permit(:title,:rating,:release_date)
    if @movie.update_attributes(permitted)
      flash[:notice] = "#{@movie.title} was successfully updated."
      redirect_to movie_path(@movie)
    else
      render 'edit' # note, 'edit' template can access @movie's field values!
    end
  end
  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
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
  def reviews
  end
end
