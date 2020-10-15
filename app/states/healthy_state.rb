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

  def put_at_risk
    @user.state = :at_risk
    @user.save
  end

  def can_get_infected?
    true
  end

  def got_infected
    @user.state = :infected
    @user.save
  end

  def discharge
    # does not change its state
  end
end
