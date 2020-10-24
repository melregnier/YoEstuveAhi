class HomeController < ApplicationController
  def index
    @user_decorator = UserDecorator.new(current_user)
    @location_decorator = LocationDecorator.new(@user_decorator.current_location) if @user_decorator.at_location?
    @notifications = current_user.user_notifications
    @notifications.each(&:destroy)
    @users_by_state = User.group(:state).count
    return admin_home if current_user.admin?
  end

  private

  def admin_home
    @locations = Location.all
    render 'admin_index'
  end
end