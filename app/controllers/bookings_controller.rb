class BookingsController < ApplicationController
  def index
    @bookings = Booking.all
  end

  def show
    @booking = Booking.find(params[:id])
  end

  def new
    @booking = Booking.new
  end

  def create
    @petsitter = Petsitter.find(params[:petsitter_id])
    @booking = Booking.new(booking_params)
    @booking.petsitter = @petsitter
    @user = current_user
    @booking.user = @user
    raise unless @booking.save

    redirect_to bookings_path(@booking)
  end

  private

  def booking_params
    params.require(:booking).permit(:user_id, :petsitter_id, :start_date, :end_date, :location)
  end
end
