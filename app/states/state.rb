class State
  def initialize(user)
    @user = user
  end

  def state_description
    raise NotImplementedError
  end

  def can_check_in?
    raise NotImplementedError
  end

  def check_in
    raise NotImplementedError
  end

  def check_out
    raise NotImplementedError
  end

  def can_get_infected?
    raise NotImplementedError
  end

  def got_infected
    raise NotImplementedError
  end

  def discharged
    raise NotImplementedError
  end
end