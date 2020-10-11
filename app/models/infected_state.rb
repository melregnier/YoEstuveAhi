class InfectedState < State
  include Singleton

  def welcome_message
    'Usted está contagiado de COVID-19, por favor mantengase en su casa y cuídese'
  end

  def can_check_in?
    false
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
    false
  end

  def got_infected
    raise NotImplementedError
  end

  def discharged
    raise NotImplementedError
  end
end
