class Api::V1::MoviesController < ApplicationController
  def index
    url = "https://api.themoviedb.org/3/movie/top_rated"
    conn = Faraday.new(url: url) do |faraday|
      faraday.headers["Authorization"] = "Bearer #{Rails.application.credentials.tmdb[:key]}"
      faraday.headers["Accept"] = "application/json"
    end

    response = conn.get
    json = JSON.parse(response.body, symbolize_names: true)
require 'pry'; binding.pry
    render json: json
  end
end