class Booking < ApplicationRecord
  belongs_to :petsitter
  belongs_to :user, dependent: :destroy
  validates :status, presence: true, inclusion: { in: %w(pending accepted declined), message: "%{value} is not a valid status" }
end
