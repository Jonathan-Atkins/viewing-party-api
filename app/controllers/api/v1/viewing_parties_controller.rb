class Api::V1::ViewingPartiesController < ApplicationController

  def create  
    new_party = ViewingParty.new(viewing_party_params)
    new_party.toggle(:host)

    if new_party.save
       params[:invitees].each do |invitee_id|
        new_party.viewing_party_invitees.create(user_id: invitee_id)
       end
      render json: ViewingPartySerializer.new(new_party), status: :created
    else
      render json: { errors: new_party.errors.full_messages }, status: 422
    end
  end

  def update
    updating_party = ViewingParty.find_by(id: params[:id])
    
    if updating_party.nil?
      render json: { error: "Viewing Party not found" }, status: :not_found and return
    end
  
    new_invitee = User.find_by(id: params[:invitee_id])
  
    if new_invitee.nil?
      render json: { error: "User ID #{params[:invitee_id]} does not exist" }, status: :not_found and return
    elsif updating_party.invitees.include?(new_invitee.id)
      render json: { error: "User ID #{params[:invitee_id]} has already been invited to the party" }, status: :unprocessable_entity and return
    end
  
    updating_party.viewing_party_invitees.create(user_id: new_invitee.id)
    render json: ViewingPartySerializer.new(updating_party), status: :ok
  end
end
