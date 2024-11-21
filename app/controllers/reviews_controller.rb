class ReviewsController < ApplicationController
  def index
    @given_reviews = Review.where(user_id: current_user)
    @received_reviews = Review.where(petsitter_id: Petsitter.where(user_id: current_user))
  end

  def create
    @booking = Booking.find(params[:booking_id])
    @petsitter = Petsitter.find(params[:petsitter_id])
    @review = Review.new(review_params)
    @review.petsitter = @petsitter
    @user = current_user
    @review.user = @user
    @review.save
    redirect_to bookings_path
  end

  def update
    @review = Review.find(params[:id])
    redirect_to reviews_path(@user)
  end

  private

  def review_params
    params.require(:review).permit(:booking_id, :user_id, :petsitter_id, :rating, :comment)
  end
end
