class BookingsController < ApplicationController
  def index
    all_bookings = Booking.all
    all_bookings.each do |booking|
      if booking.end_date < Date.today
        booking.status = "expired"
        booking.save
      end
    end
    @bookings = Booking.where(user_id: current_user)
    petsitter_ids = Petsitter.where(user_id: current_user).pluck(:id)
    @requests = Booking.where(petsitter_id: petsitter_ids)
    @review = Review.new
    @bookings -= @bookings.where(status: "declined")
    @requests -= @requests.where(status: "declined")
  end

  def cancel
    @booking = Booking.find(params[:id])
    @booking.status = 'declined'
    @booking.save
    redirect_to bookings_path, notice: "Booking successfully canceled."
  end

  def accept
    @booking = Booking.find(params[:id])
    @booking.status = 'accepted'
    @booking.save
    redirect_to bookings_path, notice: "Booking accepted."
  end


  def show
    @booking = Booking.find(params[:id])
  end

  def create
    @petsitter = Petsitter.find(params[:petsitter_id])
    @booking = Booking.new(booking_params)
    @booking.petsitter = @petsitter
    @user = current_user
    @booking.user = @user
    @booking.status = "pending"
    @booking.save
    redirect_to bookings_path(@booking)
  end

  def update
    @booking = Booking.find(params[:id])
    @booking.status = "declined"
    redirect_to bookings_path(@booking)
  end

  private

  def booking_params
    params.require(:booking).permit(:user_id, :petsitter_id, :start_date, :end_date, :location, :status)
  end
end
