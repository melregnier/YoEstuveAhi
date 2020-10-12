class LocationDecorator < SimpleDelegator
  def user_count
    user_locations.count
  end

  def has_many_users?
    user_count > 1
  end
end