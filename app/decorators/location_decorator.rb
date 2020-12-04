class LocationDecorator < SimpleDelegator
  def has_many_users?
    concurrence > 1
  end
end