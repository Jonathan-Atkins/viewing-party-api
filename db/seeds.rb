ViewingPartyInvitee.destroy_all
ViewingParty.destroy_all
User.destroy_all

user1 = User.create!(name: "Danny DeVito", username: "danny_de_v", password: "jerseyMikesRox7")
user2 = User.create!(name: "Dolly Parton", username: "dollyP", password: "Jolene123")
user3 = User.create!(name: "Lionel Messi", username: "futbol_geek", password: "test123")

viewing_party = ViewingParty.create!(
  name: "Movie Night with Friends",
  start_time: "2025-02-01T18:00:00.000Z",
  end_time: "2025-02-01T21:00:00.000Z",
  movie_id: 278,
  movie_title: "The Shawshank Redemption",
  host: true
)

ViewingPartyInvitee.create!(user: user1, viewing_party: viewing_party)
ViewingPartyInvitee.create!(user: user2, viewing_party: viewing_party)