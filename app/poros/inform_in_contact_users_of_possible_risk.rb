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
    users_to_inform = []
    

    @user.user_location_histories.each do | |

    end
  end

  def contagious_period
    initial_date = - PERIOD_OF_CONTAGIOUS_DAYS
    final_date = []
    # aca quedamos, hacer un periodo desde hasta para poder hacer el between en users_to_inform
  end

  def test_date
    @test_date ||= @user.covid_tests.positive.last.date
  end
end