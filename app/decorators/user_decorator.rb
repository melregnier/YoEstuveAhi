class UserDecorator < SimpleDelegator
  def at_location?
    user_location.present?
  end

  def current_location
    user_location&.location
  end
end