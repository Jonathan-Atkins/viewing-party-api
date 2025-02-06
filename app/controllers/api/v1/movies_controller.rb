class Api::V1::MoviesController < ApplicationController
  def index
    if params[:query]
      results = MovieGateway.search_movies(params[:query])
      render json: MovieSerializer.new(results)
    else
      top_rated = MovieGateway.get_top_rated
      render json: MovieSerializer.new(top_rated)
    end
  end
end