class UsersController < ApplicationController
  skip_before_action :authorized, only: [:new, :create]
  layout 'sessions', only: :new

  def new
    @user = User.new
  end

  def create
    @user = User.new(create_params)
    return redirect_to(new_user_path) unless @user.save

    session[:user_id] = @user.id
    redirect_to('/welcome')
  end

  private

  def create_params
    params.require(:user).permit(:name, :email, :document_number, :document_type, :password, :password_confirmation)
  end
end