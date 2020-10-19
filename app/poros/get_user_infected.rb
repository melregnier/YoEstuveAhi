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
    rescue => error
      return false
    end

    NotifyLocationsOfInfection.new(@user).perform
    InformInContactUsersOfPossibleRisk.new(@user).perform unless @user.user_location.present?
    true
  end
end