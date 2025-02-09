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

  private

  def viewing_party_params
    params.permit(:name, :start_time, :end_time, :host, :movie_id, :movie_title, invitees: [])
  end
end
