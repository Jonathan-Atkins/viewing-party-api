require 'rails_helper'

RSpec.describe "Viewing Party API", type: :request do
  describe "PATCH /api/v1/viewing_parties/:id/invitees" do
    let!(:host) { User.create(name: "Host", username: "host_user", password: "password123", password_confirmation: "password123") }
    let!(:invitee1) { User.create(name: "Barbara", username: "leo_fan", password: "password123", password_confirmation: "password123") }
    let!(:invitee2) { User.create(name: "Ceci", username: "titanic_forever", password: "password123", password_confirmation: "password123") }
    let!(:invitee3) { User.create(name: "Peyton", username: "star_wars_geek_8", password: "password123", password_confirmation: "password123") }
    let!(:new_invitee) { User.create(name: "Leo DiCaprio", username: "leo_real_verified", password: "password123", password_confirmation: "password123") }

    let!(:viewing_party) do
      ViewingParty.create(
        name: "Juliet's Bday Movie Bash!",
        start_time: "2025-02-01T10:00:00.000Z",
        end_time: "2025-02-01T14:30:00.000Z",
        movie_id: 278,
        host: true,
        invitees: [invitee1.id, invitee2.id, invitee3.id],
        movie_title: "The Shawshank Redemption"
      )
    end

    before do
      viewing_party.save!
      ViewingPartyInvitee.create(user: invitee1, viewing_party: viewing_party)
      ViewingPartyInvitee.create(user: invitee2, viewing_party: viewing_party)
      ViewingPartyInvitee.create(user: invitee3, viewing_party: viewing_party)
    end

    context "when adding a new invitee to an existing viewing party" do
      it "adds the user to the invitees list" do
        expect(viewing_party.users.count).to eq 3

        patch "/api/v1/viewing_parties/#{viewing_party.id}", params: { invitee_id: new_invitee.id }, as: :json
        expect(response).to be_successful

        json = JSON.parse(response.body)
        expect(json["data"]["attributes"]["invitees"].count).to eq(4)
        expect(json["data"]["attributes"]["invitees"].map { |i| i["id"] }).to include(new_invitee.id)
      end
    end

    context "when the viewing party ID is invalid" do
      it "returns a 404 not found error" do
        patch "/api/v1/viewing_parties/999999", params: { invitee_id: new_invitee.id }, as: :json

        expect(response).to have_http_status(:not_found)
        json = JSON.parse(response.body)

        expect(json["error"]).to eq("Couldn't find ViewingParty with 'id'=999999")
      end
    end

    context "when the user ID is invalid" do
      it "returns a 404 not found error" do
        patch "/api/v1/viewing_parties/#{viewing_party.id}", params: { invitee_id: 999999 }, as: :json

        expect(response).to have_http_status(:not_found)
        json = JSON.parse(response.body)

        expect(json["error"]).to eq("User ID 999999 does not exist")
      end
    end

    context "when the user is already invited" do
      it "returns an error message" do
        patch "/api/v1/viewing_parties/#{viewing_party.id}", params: { invitee_id: invitee1.id }, as: :json

        expect(response).to have_http_status(:unprocessable_entity)
        json = JSON.parse(response.body)

        expect(json["error"]).to eq("User ID #{invitee1.id} has already been invited to the party")
      end
    end

    context "when the invitee record fails to save" do
      it "returns an error message" do
        allow_any_instance_of(ViewingPartyInvitee).to receive(:id).and_return(nil) # Simulate a failed save

        patch "/api/v1/viewing_parties/#{viewing_party.id}", params: { invitee_id: new_invitee.id }, as: :json

        expect(response).to have_http_status(:unprocessable_entity)
        json = JSON.parse(response.body)

        expect(json["error"]).to eq("Failed to add invitee")
      end
    end
  end
end