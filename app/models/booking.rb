class Booking < ApplicationRecord
  belongs_to :user, dependent: :destroy
  belongs_to :petsitter, dependent: :destroy
  validates :user_id, :petsitter_id, :start_date, :end_date, presence: true
  validate :end_date_after_start_date
end
