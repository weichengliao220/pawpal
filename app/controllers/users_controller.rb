class UsersController < ApplicationController
  def phone_number
    @user = User.find(params[:id])
    render json: { phone_number: @user.phone_number }
  end


end
