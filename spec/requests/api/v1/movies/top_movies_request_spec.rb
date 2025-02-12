require "rails_helper"

describe "Top Movies", type: :request do
  it "returns top-rated movies" do
    VCR.use_cassette("top_movies") do 
      get "/api/v1/movies"
      expect(response).to be_successful
      expect(response.status).to eq 200
  
      movies = JSON.parse(response.body, symbolize_names: true)[:data]
      expect(movies).to be_an(Array)
      expect(movies.count).to eq 20

      movies.each do |movie|
        attrs = movie[:attributes]
        expect(movie[:id]).to be_an(String)
        expect(movie[:type]).to eq("movie")
        expect(attrs[:title]).to be_an(String)
        expect(attrs[:vote_average]).to be_an(Float)
      end
    end 
  end 
end 