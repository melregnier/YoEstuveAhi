module Users
  class InformInContactUsersOfPossibleRisk
    PERIOD_OF_CONTAGIOUS_DAYS = Rails.application.secrets.period_of_contagious_days

    def initialize(user)
      @user = user
    end  

    def perform
      user_location_histories = @user.user_location_histories.where(check_in: contagious_period)
      return if user_location_histories.empty?

      ExternalServices::InformExternalServicesOfContagion.new(user_location_histories).perform

      Users::InformInternalUsersOfPossibleRisk.new(user_location_histories).perform
    end

    private

    def contagious_period
      initial_date = test_date - PERIOD_OF_CONTAGIOUS_DAYS
      final_date = [test_date + PERIOD_OF_CONTAGIOUS_DAYS, Date.today].min
      initial_date.to_time..final_date.end_of_day
    end

    def test_date
      @test_date ||= @user.covid_tests.positive.last.date
    end
  end
end