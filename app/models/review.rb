class Review < ApplicationRecord
  belongs_to :user
  belongs_to :petsitter

  validates :rating, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 1, less_than_or_equal_to: 5 }
  validates :user_id, presence: true
  validates :petsitter_id, presence: true
end
