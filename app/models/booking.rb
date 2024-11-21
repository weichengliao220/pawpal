class Booking < ApplicationRecord
  belongs_to :user
  belongs_to :petsitter
  has_one :review
  validates :user_id, :petsitter_id, :start_date, :end_date, presence: true

  def rated?
    if Review.find_by(booking_id: self.id)
      return true
    else
      return false
    end
  end
end
