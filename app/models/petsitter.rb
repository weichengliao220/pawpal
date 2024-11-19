class Petsitter < ApplicationRecord
  belongs_to :user, dependent: :destroy
  has_many :bookings
  validates :price, presence: true
  validates :acceptable_pets, presence: true, inclusion: { in: %w(dog cat bird fish), message: "%{value} is not a valid pet type" }
  validates :bio, presence: true, length: { minimum: 5 }
end
