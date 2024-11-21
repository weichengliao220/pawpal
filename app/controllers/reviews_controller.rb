class ReviewsController < ApplicationController
  def index
    @given_reviews = Review.where(user_id: current_user)
    petsitter_ids = Review.where(user_id: current_user).pluck(:id)
    @received_reviews = Review.where(petsitter_id: petsitter_ids)
  end

  def new
    @review = Review.new
  end

  def create
    @booking = Booking.find(params[:booking_id])
    @petsitter = Petsitter.find(params[:petsitter_id])
    @review = Review.new(review_params)
    @review.petsitter = @petsitter
    @user = current_user
    @review.user = @user
    @review.save
    redirect_to reviews(@user)
  end

  def update
    @review = Review.find(params[:id])
    redirect_to reviews_path(@user)
  end

  private

  def review_params
    params.require(:review).permit(:user_id, :petsitter_id, :rating, :comment)
  end
end
