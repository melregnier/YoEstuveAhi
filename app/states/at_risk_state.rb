class AtRiskState < State
  def state_description
    'en riesgo'
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
    # create a new log to track the last moment they were put at risk
    @user.user_logs.create(created_at: Time.now, to_state: :at_risk.to_s)
  end

  def can_get_infected?
    true
  end

  def got_infected
    @user.state = :infected
    @user.save
  end

  def discharge
    @user.state = :healthy
    @user.save
  end
end
