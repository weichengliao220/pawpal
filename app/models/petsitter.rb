class Petsitter < ApplicationRecord
  VALID_ADDRESSES = %w[shinjuku shibuya meguro shinagawa roppongi]
  VALID_RATINGS = (0..10).map { |n| n * 0.5 }

  belongs_to :user, dependent: :destroy
  has_many :bookings
  has_one_attached :photo
  validates :price, presence: true
  validates :acceptable_pets, presence: true
  validates :bio, presence: true, length: { minimum: 5 }
  validates :address, presence: true, inclusion: { in: VALID_ADDRESSES }
  validates :rating, presence: true, inclusion: { in: VALID_RATINGS }
end
