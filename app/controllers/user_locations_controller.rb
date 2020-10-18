class UserLocationsController < ApplicationController
  # scan
  def new
    @user_location = UserLocation.new
  end

  def create
    id_decoded = QrDecoder.new(create_params[:qr_image].tempfile.to_path).perform
    ## falta validacion de que exista la locacion, de que no tenga otra user location, de que pueda check_inear, borrar imagen que creamos
    user_location = UserLocation.new(user: current_user, location_id: id_decoded.to_i, check_in: Time.now)
    unless user_location.save
      flash[:notice] = 'Hubo un error en el sistema. Intente nuevamente más tarde.'
      return redirect_to('/qr')
    end
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