class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = Movie.all.map(&:rating).uniq.sort
    session[:selected_ratings] = params[:ratings] unless params[:ratings].nil?
    session[:selected_ratings] ||= {}
    session[:sort_by] = params[:sort_by].to_sym unless params[:sort_by].nil?
    session[:sort_by] ||= :id
    @movies = Movie.where(:rating => params[:ratings] ? session[:selected_ratings].keys : @all_ratings).order(session[:sort_by])
    session[:hilite] = {session[:sort_by] => "hilite"}  
    # debugger
    if ((params[:ratings].nil? && !session[:selected_ratings].empty?) || (params[:sort_by].nil? && session[:sort_by] != :id))
      params[:ratings] = session[:selected_ratings]
      params[:sort_by] = session[:sort_by]
      flash.keep
      redirect_to movies_path(params)
    end
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
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
