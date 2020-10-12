class GetUserInfected
  def initialize(user, date)
    @user = user
    @date = date
  end

  def perform
    return false unless @user.can_get_infected?

    ActiveRecord::Base.transaction do 
      @user.covid_tests.create!(date: @date, result: true)
      @user.got_infected
    rescue
      return false
    end
    # notificar locaciones

    #{ cambiar estado de usuarios que compartieron tiempo a definir en los ultimos x dias
    # notificar usuarios por web
    # notificar usuarios por mail }  Si usuario no se encuentra en locacion lo hacemos, sino se hace en checkout
  end
end