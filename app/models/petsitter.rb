class Petsitter < ApplicationRecord
  belongs_to :user
  has_many :bookings, dependent: :destroy

  validates :price, presence: true
  validates :acceptable_pets, presence: true
  validates :bio, presence: true, length: { minimum: 5 }
end
