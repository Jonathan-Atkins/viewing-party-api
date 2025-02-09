class Api::V1::ViewingPartiesController < ApplicationController
  # before_action :check_params, only: [:create]

  def create  
    new_party = ViewingParty.new(viewing_party_params)
    
    if new_party.save
      new_party.toggle(:host)
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
    params.permit(:name, :start_time, :end_time, :movie_id, :movie_title, invitees: [])
  end
end
