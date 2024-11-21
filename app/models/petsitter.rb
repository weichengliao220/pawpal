class Petsitter < ApplicationRecord
  belongs_to :user, dependent: :destroy
  has_many :bookings
  has_many :reviews, dependent: :destroy
  has_one_attached :photo
  validates :price, presence: true
  validates :acceptable_pets, presence: true
  validates :bio, presence: true, length: { minimum: 5 }

  def average_rating
    return 0.0 if reviews.empty?

    sprintf('%.1f', reviews.average(:rating).to_f)
  end
end
