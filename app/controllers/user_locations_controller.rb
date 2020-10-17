class UserLocationsController < ApplicationController
  # scan
  def new
    @user_location = UserLocation.new
  end

  def create
    qr_decoded = QrDecoder.new(create_params[:qr_image].tempfile.to_path).perform
    user_location = UserLocation.new(user: current_user, location: qr_decoded)
    return redirect_to(new_location_path) unless true
    redirect_to('/home')
  end

  # llama a crear un history
  def destroy
  end

  private

  def create_params
    params.require(:user_location).permit(:qr_image)
  end
end