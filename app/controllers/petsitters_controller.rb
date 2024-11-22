class PetsittersController < ApplicationController
  def index
    @breeds = ["dog", "cat", "bird", "fish"]
    @locations = ["shinjuku", "shibuya", "shinagawa", "meguro", "roppongi"]
    @petsitters = Petsitter.all

    if params[:breed].present?
      # @petsitters = @petsitters.select { |petsitter| petsitter.acceptable_pets.include?(params[:breed]) }
      @petsitters = @petsitters.where('acceptable_pets ILIKE ?', "%#{params[:breed]}%")
    end

    if params[:location].present?
      # @petsitters = @petsitters.select { |petsitter| petsitter.address.include?(params[:location]) }
      @petsitters = @petsitters.joins(:user).where('users.address ILIKE ?', "%#{params[:location]}%")
    end
  end

  def show
    @petsitter = Petsitter.find(params[:id])
    @bookings = Booking.where(petsitter_id: @petsitter.id)
    @booking = Booking.new
    @user = current_user
    @reviews = Review.where(petsitter_id: @petsitter.id)
  end

  def new
    @petsitter = Petsitter.new
  end

  def create
    @petsitter = Petsitter.new(petsitter_params)
    @petsitter.user = current_user

    if @petsitter.save
      redirect_to petsitter_path(@petsitter), notice: 'Successfully became a petsitter!'
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def petsitter_params
    params.require(:petsitter).permit(:user_id, :bio, :price, :picture_url, :address, :photo, acceptable_pets: [])
  end
end
