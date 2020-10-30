class LocationsController < ApplicationController
  def index
    @locations = Location.where(user_id: current_user.id)
  end

  def new
    @location = Location.new
  end

  def create
    byebug
    location = Location.create!(create_params.merge(user_id: current_user.id))
    redirect_to(location_path(location.id))
  end

  def show
    @location = Location.find(params.require(:id))
    @qr_code = RQRCode::QRCode.new(@location.id.to_s).as_svg
  end

  private

  def create_params
    params.require(:location).permit(:name, :capacity, :street, :country, :street_number, :zip_code, :location_image)
  end
end
