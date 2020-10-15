class InfectedState < State
  def state_description
    'contagiado'
  end

  def can_check_in?
    false
  end

  def check_in
    raise NotImplementedError
  end

  def check_out
    raise NotImplementedError
  end

  def put_at_risk
    raise InvalidUserOperation
  end

  def can_get_infected?
    false
  end

  def got_infected
    raise InvalidUserOperation
  end

  def discharge
    @user.state = :healthy
    @user.save
  end
end
