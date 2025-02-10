require "rails_helper"

describe "Movies Search", type: :request do
  it "returns movies matching the query", :vcr do
    json_response = File.read("spec/fixtures/tmdb_movie_response.json")
    stub_request(:get, "https://api.themoviedb.org//3/search/movie?query=Lord").
      with(
        headers: {
          'Accept'=>'application/json',
          'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
          'Authorization'=>"Bearer #{Rails.application.credentials.tmdb[:key]}",
          'User-Agent'=>'Faraday v2.10.1'
          }).
        to_return(status: 200, body: json_response, headers: {})

  get "/api/v1/movies", params: { query: "Lord" }
    expect(response).to be_successful
    expect(response.status).to eq 200

    movies = JSON.parse(response.body, symbolize_names: true)[:data]
    expect(movies).to be_an(Array)

    movies.each do |movie|
      attrs = movie[:attributes]
      expect(movie[:id]).to be_an(String)
      expect(movie[:type]).to eq("movie")
      expect(attrs[:title]).to include("Lord").or include("L.O.R.D")
      expect(attrs[:vote_average]).to be_an(Float)
    end    

    expect(movies[0][:attributes][:title]).to eq("Lord")
    expect(movies[1][:attributes][:title]).to eq("The Lord of the Rings: The War of the Rohirrim")
  end
end