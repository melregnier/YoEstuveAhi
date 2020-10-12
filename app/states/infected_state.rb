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

  def can_get_infected?
    false
  end

  def got_infected
    raise InvalidUserOperation
  end

  def discharged
    raise NotImplementedError
  end
end
