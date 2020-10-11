class LocationsController < ApplicationController
  def index
    @locations = Location.where(user_id: params[:user_id])
  end

  def new
    @location = Location.new
  end

  def create
    location = Location.new(create_params)
    return redirect_to(new_location_path) unless location.save

    redirect_to(location_path(location.id))
  end

  def show
    @location = Location.find(params.require(:id))
  end

  private

  def create_params
    params.require(:location).permit(:name, :user_id, :capacity, :latitude, :longitude)
  end
end
