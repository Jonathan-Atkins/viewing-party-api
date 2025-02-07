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
require 'pry'; binding.pry
    context "when request is valid" do
      it "creates a viewing party and invites users" do
        post "/api/v1/viewing_parties", params: valid_params, as: :json

        expect(response).to have_http_status(:created)
        json = JSON.parse(response.body, symbolize_names: true)
        
        expect(json[:data]).to include(
          id: a_kind_of(String),
          type: "viewing_party",
          attributes: a_hash_including(
            name: valid_params[:name],
            start_time: valid_params[:start_time],
            end_time: valid_params[:end_time],
            movie_id: valid_params[:movie_id],
            movie_title: valid_params[:movie_title]
          )
        )

        expect(json[:data][:attributes][:invitees].count).to eq(3)
        expect(json[:data][:attributes][:invitees]).to include(
          a_hash_including(id: invitee1.id, name: invitee1.name, username: invitee1.username),
          a_hash_including(id: invitee2.id, name: invitee2.name, username: invitee2.username),
          a_hash_including(id: invitee3.id, name: invitee3.name, username: invitee3.username)
        )
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