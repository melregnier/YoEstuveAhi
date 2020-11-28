class LocationsController < ApplicationController
  RUBY_SERVER_ID = Rails.application.secrets.ruby_server_id

  def index
    @locations = Location.where(user_id: current_user.id)
  end

  def new
    @location = Location.new
  end

  def create
    location = Location.create!(create_params.merge(user_id: current_user.id))
    redirect_to(location_path(location.id))
  end

  def show
    @location = Location.find(params.require(:id))
    @qr_code = RQRCode::QRCode.new({ location_id: @location.id, server_id: RUBY_SERVER_ID }.to_json).as_svg
    
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @location }
    end
  end

  private

  def create_params
    params.require(:location).permit(:name, :capacity, :street, :country, :street_number, :zip_code, :location_image)
  end
end
