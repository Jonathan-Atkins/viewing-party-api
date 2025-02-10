class ViewingPartySerializer
  include JSONAPI::Serializer
  attributes :name, :start_time, :end_time, :movie_id, :movie_title
  has_many :users, serializer: UserSerializer

  attribute :invitees do |obj|
    obj.users.map do |user|
      {
        id: user.id,
        name: user.name,
        username: user.username
      }
    end
  end
end