class InformInContactUsersOfPossibleRisk
  PERIOD_OF_CONTAGIOUS_DAYS = Rails.application.secrets.period_of_contagious_days
  MINUTES_EXPOSED_TO_BE_AT_RISK = Rails.application.secrets.minutes_exposed_to_be_at_risk

  def initialize(user)
    @user = user
  end
#{ cambiar estado de usuarios que compartieron tiempo a definir en los ultimos x dias
# notificar usuarios por web
# notificar usuarios por mail }  Si usuario no se encuentra en locacion lo hacemos, sino se hace en checkout
  
  def perform
    true
  end

  private

  def users_to_inform
    users_to_inform = Set.new

    @user.user_location_histories.where(date: contagious_period).each do | user_location |
      user_location_histories = overlapping_user_location_histories(user_location).select do | overlapping_user_location |
        MINUTES_EXPOSED_TO_BE_AT_RISK <= contact_time(user_location, overlapping_user_location).minutes
      end
      users_to_inform.merge(user_location_histories.map(&:user))
    end
    users_to_inform
  end

  def contagious_period
    initial_date = test_date - PERIOD_OF_CONTAGIOUS_DAYS
    final_date = [test_date + PERIOD_OF_CONTAGIOUS_DAYS, Date.today].min
    initial_date..final_date
  end

  def test_date
    @test_date ||= @user.covid_tests.positive.last.date
  end

  def overlapping_user_location_histories(user_location)
    UserLocationHistory.where(location_id: user_location.location_id).where(
      [
        overlapping_check_in_condition, 
        overlapping_check_out_condition, 
        overlapping_containing_condition
      ].join(' OR '),
      {check_in: user_location.check_in, check_out: user_location.check_out})
  end

  def overlapping_check_in_condition
    '(check_in >= :check_in AND check_in <= :check_out)'
  end

  def overlapping_check_out_condition
    '(check_out >= :check_in AND check_out <= :check_out)'
  end

  def contact_time(user_location_fst, user_location_snd)
    [user_location_fst.check_out, user_location_snd.check_out].min -
    [user_location_fst.check_in, user_location_snd.check_in].max
  end

  def overlapping_containing_condition
    '(check_in < :check_in AND check_out > :check_out)'
  end
end