class ApplicationController < ActionController::Base
  before_action :authorized
  helper_method :current_user
  helper_method :logged_in?
  rescue_from Errors::InvalidUserOperation, with: :invalid_user_operation
  
  def invalid_user_operation
    flash[:notice] = "Operación no permitida"
  end
  
  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end

  def logged_in?
    !current_user.nil?
  end

  def authorized
    redirect_to '/welcome' unless logged_in?
  end
end
