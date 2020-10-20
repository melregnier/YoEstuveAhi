class ApplicationController < ActionController::Base
  before_action :authorized
  helper_method :current_user
  helper_method :logged_in?
  rescue_from Errors::InvalidUserOperation, with: :invalid_user_operation
  rescue_from Errors::InvalidQR, with: :invalid_qr
  rescue_from Errors::LocationNotFound, with: :location_not_found
  rescue_from ActiveRecord::ActiveRecordError, with: :generic_error
  rescue_from Errors::LocationFull, with: :location_full
  
  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end
  
  def logged_in?
    !current_user.nil?
  end
  
  def authorized
    redirect_to '/welcome' unless logged_in?
  end
  
  private

  ## Error Handling
  
  def invalid_user_operation
    flash[:notice] = 'Operación no permitida.'
    redirect_to('/home')
  end

  def invalid_qr
    flash[:notice] = 'No se pudo leer el QR. Por favor, intente con una imagen más clara.'
    redirect_to('/home')
  end

  def location_not_found
    flash[:notice] = 'No se ha podido encontrar la locación.'
    redirect_to('/home')
  end

  def generic_error(exception)
    byebug
    flash[:notice] = 'Hubo un error en el sistema. Intente nuevamente más tarde.'
    redirect_to('/home')
  end

  def location_full
    flash[:notice] = 'El local se encuentra lleno actualmente. Intente nuevamente más tarde.'
    redirect_to('/home')
  end
end
