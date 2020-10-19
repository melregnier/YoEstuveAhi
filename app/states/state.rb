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

  def put_at_risk
    raise NotImplementedError
  end

  def can_get_infected?
    raise NotImplementedError
  end

  def got_infected
    raise NotImplementedError
  end

  def discharge
    raise NotImplementedError
  end
end
