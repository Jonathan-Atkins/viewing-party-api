require "rails_helper"

RSpec.describe "Viewing Party API", type: :request do
  describe "POST /api/v1/viewing_parties" do
    let!(:host) { User.create(name: "Host", username: "host_user", password: "password123", password_confirmation: "password123") }
    let!(:invitee1) { User.create(name: "Barbara", username: "leo_fan", password: "password123", password_confirmation: "password123") }
    let!(:invitee2) { User.create(name: "Ceci", username: "titanic_forever", password: "password123", password_confirmation: "password123") }
    let!(:invitee3) { User.create(name: "Peyton", username: "star_wars_geek_8", password: "password123", password_confirmation: "password123") }
    
    let(:valid_params) do
      {
        viewing_party: {
          name: "Juliet's Bday Movie Bash!",
          start_time: "2025-02-01T10:00:00.000Z",
          end_time: "2025-02-01T14:30:00.000Z",
          movie_id: 278,
          host: false,
          movie_title: "The Shawshank Redemption",
          invitees: [invitee1.id, invitee2.id, invitee3.id]
        }
      }
    end
    
    context "when request is valid" do
      it "creates a viewing party and invites users" do
        post "/api/v1/viewing_parties", params: valid_params, as: :json
    
        expect(response).to be_successful
        json = JSON.parse(response.body, symbolize_names: true)[:data]
    
        params = valid_params[:viewing_party]
        attrs = json[:attributes]
    
        expect(json).to be_an(Hash)
        expect(json[:id]).to be_an(String)
        expect(json[:type]).to eq("viewing_party")
        expect(attrs).to be_a(Hash)
    
        expect(attrs[:name]).to eq(params[:name])
        expect(attrs[:start_time]).to eq(params[:start_time])
        expect(attrs[:end_time]).to eq(params[:end_time])
        expect(attrs[:movie_id]).to eq(params[:movie_id])
        expect(attrs[:movie_title]).to eq(params[:movie_title])
        expect(attrs[:invitees]).to be_an(Array)
        expect(attrs[:invitees].count).to eq(3)
        expect(attrs[:invitees].map { |invitee| invitee[:id] }).to include(invitee1.id, invitee2.id, invitee3.id)
      end
    end

    context "when request is missing required fields" do
      it "returns an error message" do
        post "/api/v1/viewing_parties", params: { name: "Incomplete Party" }, as: :json

        expect(response).to have_http_status(:unprocessable_entity)
        json = JSON.parse(response.body, symbolize_names: true)
        expect(json[:errors]).to include("Start time can't be blank", "End time can't be blank", "Movie can't be blank", "Movie title can't be blank")
      end
    end
  end
end