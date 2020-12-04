class ApplicationController < ActionController::Base
  skip_before_action :verify_authenticity_token
  before_action :authorized, unless: :json_format? 
  helper_method :current_user
  helper_method :logged_in?
  rescue_from Errors::InvalidUserOperation, with: lambda { json_format? ? invalid_user_operation_json : invalid_user_operation }
  rescue_from Errors::EmailAlreadyTaken, with: :email_already_taken
  rescue_from Errors::InvalidQR, with: :invalid_qr
  rescue_from Errors::LocationNotFound, with: lambda { json_format? ? location_not_found_json : location_not_found } 
  rescue_from ActiveRecord::ActiveRecordError, with: lambda { json_format? ? generic_error_json : generic_error }
  rescue_from Errors::LocationFull, with: lambda { json_format? ? location_full_json : location_full }
  rescue_from Errors::InvalidTest, with: :invalid_test
  rescue_from Errors::ExternalApiException, with: lambda {|exc| json_format? ? external_api_error_json : external_api_error(exc) }
  
  layout :application_layout

  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end
  
  def logged_in?
    !current_user.nil?
  end
  
  
  private
  
  def authorized
    redirect_to '/welcome' unless logged_in?
  end

  def json_format?
    request.format.json?
  end

  def application_layout
    current_user&.admin? ? 'admin' : 'application' 
  end
  ## Error Handling
  
  def invalid_user_operation
    flash[:notice] = 'Operación no permitida.'
    redirect_to('/home')
  end

  def invalid_user_operation_json
    render status: :unprocessable_entity, json: { message: 'Operación no permitida.' }
  end

  def invalid_qr
    flash[:notice] = 'No se pudo leer el QR. Por favor, intente con una imagen más clara.'
    redirect_to('/home')
  end

  def location_not_found
    flash[:notice] = 'No se ha podido encontrar la locación.'
    redirect_to('/home')
  end

  def location_not_found_json
    render status: :not_found, json: { message: 'Locación no encontrada.' }
  end

  def generic_error(exception)
    logger.error(exception)
    flash[:notice] = 'Hubo un error en el sistema. Intente nuevamente más tarde.'
    redirect_to('/home')
  end

  def generic_error_json
    render status: :unprocessable_entity, json: { message: 'Algo salió mal.' }
  end

  def location_full
    flash[:notice] = 'El local se encuentra lleno actualmente. Intente nuevamente más tarde.'
    redirect_to('/home')
  end

  def location_full_json
    render status: :unprocessable_entity, json: { message: 'La locación está llena.' }
  end

  def invalid_test
    flash[:notice] = 'No se pudo registrar el test.'
    redirect_to('/home')
  end

  def email_already_taken
    flash[:notice] = 'Ese email ya se encuentra registrado.'
    redirect_to(new_user_path)
  end

  def external_api_error(exception)
    flash[:notice] = exception.message
    redirect_to('/home')
  end

  def external_api_error_json
    render status: :unprocessable_entity, json: { message: 'Error externo.' }
  end
end
