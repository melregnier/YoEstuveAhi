class SessionsController < ApplicationController
  skip_before_action :authorized

  def welcome
    redirect_to('/home') if logged_in?
  end

  def create
    @user = User.find_by(email: params[:email])
    return redirect_to('/login') unless @user && @user.authenticate(params[:password])

    session[:user_id] = @user.id
    redirect_to('/home')
  end

  def destroy
    session.delete(:user_id)
    @current_user = nil
    redirect_to('/welcome')
  end
end
