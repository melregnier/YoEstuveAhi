class State
  include Singleton

  def welcome_message
    raise NotImplementedError
  end

  def can_check_in?
    raise NotImplementedError
  end

  def check_in
    raise NotImplementedError
  end

  def can_check_out?
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
