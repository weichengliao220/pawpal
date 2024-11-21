class ReviewsController < ApplicationController
  def index
    @given_reviews = Review.where(user_id: current_user)
    @received_reviews = Review.where(petsitter_id: Petsitter.where(user_id: current_user))
  end

  def create
    @booking = Booking.find(params[:booking_id])
    @review = Review.new(review_params)
    @review.booking = @booking
    @review.petsitter = @booking.petsitter
    @review.user = current_user

    if @review.save
      redirect_to bookings_path, notice: 'Review submitted successfully!'
    else
      redirect_to bookings_path, alert: 'Error creating review.'
    end
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
