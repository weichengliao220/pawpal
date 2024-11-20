class PetsittersController < ApplicationController
  def index
    @petsitters = Petsitter.all
    @breeds = ["dog", "cat", "bird", "fish"]
    # @addresses = ["shinjuku", "shibuya", "meguro", "shinagawa", "roppongi"]
  end

  def show
    @petsitter = Petsitter.find(params[:id])
    @bookings = Booking.where(petsitter_id: @petsitter.id)
    @booking = Booking.new
    @user = current_user
  end

  def new
    @petsitter = Petsitter.new
  end

  def create
    @petsitter = Petsitter.new(petsitter_params)
    @petsitter.user = current_user
    if @petsitter.save
      redirect_to petsitter_path(@petsitter)
    else
      render :new
    end
  end

  private

  def petsitter_params
    params.require(:petsitter).permit(:user_id, :bio, :price, :picture_url, :address, :photo)
  end
end
