class MoviesController < ApplicationController

  def new
    render template: "/movies/new"
  end

  def edit
    @the_movie = Movie.where(id: params.fetch(:id))[0]
    render(template: "movies/edit")
  end

  def index
    matching_movies = Movie.all

    @list_of_movies = matching_movies.order({ :created_at => :desc })

    render({ :template => "movies/index" })
  end

  def show
    the_id = params.fetch("id")

    matching_movies = Movie.where({ :id => the_id })

    # @the_movie = matching_movies.at(0)
    @the_movie = matching_movies[0]

    render({ :template => "movies/show" })
  end

  def create
    @the_movie = Movie.new
    @the_movie.title = params.fetch("query_title")
    @the_movie.description = params.fetch("query_description")
    @the_movie.released = params.fetch("query_released", false)

    if @the_movie.valid?
      @the_movie.save
      redirect_to("/movies", { :notice => "Movie created successfully." })
    else
      cookies[:title] = params.fetch("query_title")
      cookies[:description] = params.fetch("query_description")
      # cookies[:released] = params.fetch("query_released")

      # redirect_to("/movies/new", { :alert => @the_movie.errors.full_messages.to_sentence })
      render template: "movies/with_errors"
    end
  end

  def update
    the_id = params.fetch("id")
    the_movie = Movie.where({ :id => the_id }).at(0)

    the_movie.title = params.fetch("query_title")
    the_movie.description = params.fetch("query_description")
    the_movie.released = params.fetch("query_released", false)

    if the_movie.valid?
      the_movie.save
      redirect_to("/movies/#{the_movie.id}", { :notice => "Movie updated successfully."} )
    else
      redirect_to("/movies/#{the_movie.id}", { :alert => the_movie.errors.full_messages.to_sentence })
    end
  end

  def destroy
    the_id = params.fetch("id")
    the_movie = Movie.where({ :id => the_id })[0]

    the_movie.destroy

    redirect_to("/movies", { :notice => "Movie deleted successfully."} )
  end
end
