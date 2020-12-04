class ExternalUserLocationsController < ApplicationController
  def check_in
    @location = Location.find_by(id: params[:id])
    raise Errors::LocationNotFound if @location.nil?

    raise Errors::LocationFull if @location.full?

    @location.update!(concurrence: @location.concurrence + 1)
    render status: :ok, json: @location
  end

  def check_out
    @location = Location.find_by(id: params[:id])
    raise Errors::LocationNotFound if @location.nil?

    @location.update!(concurrence: @location.concurrence - 1)
    head :ok
  end
end