class SessionsController < ApplicationController
  skip_before_action :authorized
  layout 'sessions'

  def welcome
    redirect_to('/home') if logged_in?
  end

  def create
    @user = User.find_by(email: params[:email])
    return credential_error unless @user && @user.authenticate(params[:password])

    session[:user_id] = @user.id
    redirect_to('/home')
  end

  def destroy
    session.delete(:user_id)
    @current_user = nil
    redirect_to('/welcome')
  end

  private 

  def credential_error
    flash[:notice] = 'Error en las credenciales'
    redirect_to('/login')
  end
end
