class UserLocationsController < ApplicationController
  # scan
  def new
    @user_location = UserLocation.new
  end

  def create
    CheckInUser.new(qr_image, current_user).perform
    redirect_to('/home')
  end

  def destroy
    CheckOutUser.new(qr_image, current_user).perform
    redirect_to('/home')
  end

  private

  def qr_image
    params.require(:user_location)[:qr_image]
  end
end