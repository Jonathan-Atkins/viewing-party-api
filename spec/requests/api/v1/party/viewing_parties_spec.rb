require "rails_helper"

RSpec.describe "Viewing Party API", type: :request do
  describe "POST /api/v1/viewing_parties" do
    let!(:host) { User.create(name: "Host", username: "host_user", password: "password123", password_confirmation: "password123") }
    let!(:invitee1) { User.create(name: "Barbara", username: "leo_fan", password: "password123", password_confirmation: "password123") }
    let!(:invitee2) { User.create(name: "Ceci", username: "titanic_forever", password: "password123", password_confirmation: "password123") }
    let!(:invitee3) { User.create(name: "Peyton", username: "star_wars_geek_8", password: "password123", password_confirmation: "password123") }
    
    let(:valid_params) do
      {
        name: "Juliet's Bday Movie Bash!",
        start_time: "2025-02-01T10:00:00.000Z",
        end_time: "2025-02-01T14:30:00.000Z",
        movie_id: 278,
        host: false,
        movie_title: "The Shawshank Redemption",
        invitees: [invitee1.id, invitee2.id, invitee3.id]
      }
    end
    
    context "when request is valid" do
      it "creates a viewing party and invites users" do
        post "/api/v1/viewing_parties", params: valid_params

        expect(response).to be_successful
        json = JSON.parse(response.body, symbolize_names: true)[:data]
        
        expect(json).to be_an(Hash)
        expect(json[:id]).to be_an(String)
        expect(json[:type]).to eq("viewing_party")
        expect(json[:attributes]).to be_a(Hash)
        expect(json[:attributes][:name]).to eq(valid_params[:name])
        expect(json[:attributes][:start_time]).to eq(valid_params[:start_time])
        expect(json[:attributes][:end_time]).to eq(valid_params[:end_time])
        expect(json[:attributes][:movie_id]).to eq(valid_params[:movie_id])
        expect(json[:attributes][:movie_title]).to eq(valid_params[:movie_title])
        expect(json[:attributes][:invitees]).to be_an(Array)
        expect(json[:attributes][:invitees].count).to eq(3)
        expect(json[:attributes][:invitees].map { |invitee| invitee[:id] }).to include(invitee1.id, invitee2.id, invitee3.id)
      end
    end

    context "when request is missing required fields" do
      it "returns an error message" do
        post "/api/v1/viewing_parties", params: { name: "Incomplete Party" }, as: :json
        
        invalid_params = 
        expect(response).to have_http_status(:unprocessable_entity)
        json = JSON.parse(response.body, symbolize_names: true)
        expect(json[:errors]).to include("Start time can't be blank", "End time can't be blank", "Movie can't be blank", "Movie title can't be blank")
      end
    end
  end
end