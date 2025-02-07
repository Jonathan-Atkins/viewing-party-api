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
        start_time: "2025-02-01 10:00:00",
        end_time: "2025-02-01 14:30:00",
        movie_id: 278,
        movie_title: "The Shawshank Redemption",
        host_id: host.id,
        invitees: [invitee1.id, invitee2.id, invitee3.id]
      }
    end
    context "when request is valid" do
      it "creates a viewing party and invites users" do
        post "/api/v1/viewing_parties", params: valid_params, as: :json

        expect(response).to be_successful
        json = JSON.parse(response.body, symbolize_names: true)
        
        expect(json[:data]).to be_an(Hash)
        expect(json[:data][:id]).to be_an(String)
        expect(json[:data][:type]).to eq("viewing_party")
        expect(json[:data][:attributes]).to be_a(Hash)
        expect(json[:data][:attributes][:name]).to eq(valid_params[:name])
        expect(json[:data][:attributes][:start_time]).to eq(valid_params[:start_time])
        expect(json[:data][:attributes][:end_time]).to eq(valid_params[:end_time])
        expect(json[:data][:attributes][:movie_id]).to eq(valid_params[:movie_id])
        expect(json[:data][:attributes][:movie_title]).to eq(valid_params[:movie_title])
        expect(json[:data][:attributes][:invitees]).to be_an(Array)
        expect(json[:data][:attributes][:invitees].count).to eq(3)
        expect(json[:data][:attributes][:invitees].map { |invitee| invitee[:id] }).to include(invitee1.id, invitee2.id, invitee3.id)
      end
    end

    context "when request is missing required fields" do
      it "returns an error message" do
        post "/api/v1/viewing_parties", params: { name: "Incomplete Party" }, as: :json
        
        expect(response).to have_http_status(:unprocessable_entity)
        json = JSON.parse(response.body, symbolize_names: true)
        expect(json[:errors]).to include("Start time can't be blank", "Host must exist")
      end
    end
  end
end