class HomeController < ApplicationController
  def index
    @user_decorator = UserDecorator.new(current_user)
    @location_decorator = LocationDecorator.new(@user_decorator.current_location) if @user_decorator.at_location?
    return render 'admin_index' if current_user.admin?
  end
end