class UserLocationsController < ApplicationController
  # scan
  def new_checkin
    @user_location = UserLocation.new
  end

  def new_checkout
    @user_location = current_user.user_location
    raise Errors::InvalidUserOperation unless @user_location.present?
  end

  def create
    Users::CheckInUser.new(qr_image, current_user).perform
    redirect_to('/home')
  end

  def destroy
    Users::CheckOutUser.new(qr_image, current_user).perform
    redirect_to('/home')
  end

  private

  def qr_image
    params.require(:user_location)[:qr_image]
  end
end