class HealthyState < State
  def state_description
    'sano'
  end

  def can_check_in?
    true
  end

  def check_in
    raise NotImplementedError
  end
  
  def check_out
    raise NotImplementedError
  end

  def can_get_infected?
    true
  end

  def got_infected
    @user.state = User.state[:infected]
  end

  def discharged
    raise NotImplementedError
  end
end
