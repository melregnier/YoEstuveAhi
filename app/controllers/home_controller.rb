class HomeController < ApplicationController
  def index
    return render 'inside' if current_user.user_location

    render 'outside'
  end
end