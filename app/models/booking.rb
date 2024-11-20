class Booking < ApplicationRecord
  belongs_to :user
  belongs_to :petsitter
  validates :user_id, :petsitter_id, :start_date, :end_date, presence: true
end
