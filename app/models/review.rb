class Review < ApplicationRecord
  belongs_to :user
  belongs_to :petsitter
  belongs_to :booking

  validates :rating, presence: true, inclusion: { in: 1..5 }
  validates :user_id, presence: true
  validates :petsitter_id, presence: true
  validates :booking_id, presence: true
end
