require "rails_helper"

RSpec.describe MovieGateway do
  it "should make a call to TMdb to retrieve movie data", :vcr do
    VCR.use_cassette("should_make_a_call_to_TMdb_to_retrieve_movie_data") do
      json_response = MovieGateway.get_top_rated

      movies = json_response.map do |movie|
        expect(movie.title).to be_an(String)
        expect(movie.vote_average).to be_an(Float)
      end
    end
  end
end