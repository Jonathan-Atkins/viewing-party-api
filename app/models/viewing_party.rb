class ViewingParty < ApplicationRecord
  has_many :viewing_party_invitees
  has_many :users, through: :viewing_party_invitees

  validates :name, presence: true
  validates :invitees, presence: true
  validate :movie_id_or_movie_title

  private

  def movie_id_or_movie_title
    if movie_id.blank? && movie_title.blank?
      errors.add(:base, "Movie ID or Title must be present")
    end
  end
end