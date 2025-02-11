class Api::V1::ViewingPartiesController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :not_found

  def create  
    new_party = ViewingParty.new(viewing_party_params)
    new_party.toggle(:host)

    if new_party.save
      # Create viewing_party_invitees for each invitee
      params[:viewing_party][:invitees].each do |invitee_id|
        new_party.viewing_party_invitees.create(user_id: invitee_id)
      end
      render json: ViewingPartySerializer.new(new_party), status: :created
    else
      render json: { errors: new_party.errors.full_messages }, status: 422
    end
  end

  def update
    begin
      updating_party = ViewingParty.find(params[:id])
    rescue ActiveRecord::RecordNotFound => e
      render json: { error: e.message }, status: :not_found and return
    end
  
    new_invitee = User.find_by(id: params[:invitee_id])
  
    if new_invitee.nil?
      render json: { error: "User ID #{params[:invitee_id]} does not exist" }, status: :not_found and return
    elsif updating_party.invitees.include?(new_invitee.id)
      render json: { error: "User ID #{params[:invitee_id]} has already been invited to the party" }, status: :unprocessable_entity and return
    end
  
    new_invitee_record = updating_party.viewing_party_invitees.create(user_id: new_invitee.id)
  
    if new_invitee_record.id.nil?
      render json: { error: "Failed to add invitee" }, status: :unprocessable_entity and return
    end
  
    render json: ViewingPartySerializer.new(updating_party), status: :ok
  end

  private

  def viewing_party_params
    params.require(:viewing_party).permit(:name, :start_time, :end_time, :movie_id, :movie_title, invitees: [])
  end

  def not_found
    render json: { error: "Viewing Party not found" }, status: :not_found
  end
end