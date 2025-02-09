class MovieGateway 
  
  def self.get_top_rated
    movies = connect_to_gateway("/3/movie/top_rated")
    movies.map { |m| Movie.new(m) }
  end
  
  def self.search_movies(query)
    movies = connect_to_gateway("/3/search/movie?query=#{query}")
    movies.map { |m| Movie.new(m) }
  end


  private

  def self.connect_to_gateway(endpoint)
    url = "https://api.themoviedb.org#{endpoint}"
    
    conn = Faraday.new(url: url) do |faraday|
      faraday.headers["Authorization"] = Rails.application.credentials.tmdb[:key]
      faraday.headers["Accept"] = "application/json"
    end

    response = conn.get
    parse_data(conn.get)
  end
  
  def self.parse_data(response)
    JSON.parse(response.body, symbolize_names: true)[:results]
  end
end