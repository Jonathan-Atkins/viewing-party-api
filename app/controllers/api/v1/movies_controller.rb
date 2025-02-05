class Api::V1::MoviesController < ApplicationController
  def index
    # if params[:top_movies]
  conn = Faraday.new(url: "https://api.themoviedb.org/3/movie/top_rated") do |faraday|
    faraday.headers["Authorization"] = 'Bearer 00b9635b34e0ab1a6757822f885f9ff3'
  end 
  
  
  
end