class ViewingParty < ApplicationRecord
  has_many :viewing_party_invitees
  has_many :users, through: :viewing_party_invitees

  validates :name, :start_time, :end_time, :movie_id, :host, :movie_title, presence: true

  def self.find_party(party_id)
    party = find_by(id: party_id)
    return { error: "Viewing Party not found" } unless party

    party
  end
  
  def self.find_user(invitee_id, party)
    new_invitee    = User.find_by(id: invitee_id)
    new_invitee_id = new_invitee.id

    unless User.exists?(new_invitee_id)
      return render json: { error: "User ID:#{new_invitee_id}/Name: #{new_invitee.name} does not exist" }, status: :not_found
    end
    if party.invitees.include?(new_invitee_id)
      return redner json: { error: "User ID:#{new_invitee_id} has already been invited to the party" }, status: :not_found
    end
  
    new_invitee_id
  end
end