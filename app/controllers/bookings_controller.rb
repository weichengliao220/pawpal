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
    @booking.user = current_user
    if @booking.save
      redirect_to booking_path(@booking)
    else
      raise
    end
  end

  private

  def booking_params
    params.require(:booking).permit(:start_date, :end_date)
  end
end
