class Petsitter < ApplicationRecord
  belongs_to :user, dependent: :destroy
  has_many :bookings
  has_many :reviews, dependent: :destroy
  has_one_attached :photo
  validates :price, presence: true
  validates :acceptable_pets, presence: true
  validates :bio, presence: true, length: { minimum: 5 }
end
