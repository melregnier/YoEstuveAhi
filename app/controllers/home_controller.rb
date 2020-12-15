class HomeController < ApplicationController

  def index
    @user_decorator = UserDecorator.new(current_user)
    return admin_home if current_user.admin?

    @user_decorator.current_location.update_concurrence if @user_decorator.at_location?
    @location_decorator = LocationDecorator.new(@user_decorator.current_location) if @user_decorator.at_location?
    @notifications = current_user.user_notifications
    @notifications.each(&:destroy)
  end

  private

  def admin_home
    @locations = Location.all
    @locations_by_capacity = Location.group(:capacity).count
    @users_by_state = User.group(:state).count
    render 'admin_index'
  end
end