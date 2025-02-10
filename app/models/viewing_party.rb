class ViewingParty < ApplicationRecord
  has_many :viewing_party_invitees
  has_many :users, through: :viewing_party_invitees

  validates :name, :start_time, :end_time, :movie_id, :host, :movie_title, presence: true
end