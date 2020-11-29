module Notifications
  class NotifyLocationsOfInfection
    PERIOD_OF_CONTAGIOUS_DAYS = Rails.application.secrets.period_of_contagious_days

    def initialize(infected_user)
      @infected_user = infected_user
    end

    def perform
      locations_to_notify.each do | location |
        UserMailer.with(user: location.user).location_at_risk_email.deliver_now if location.user_id.present?
      end
    end

    private

    def locations_to_notify
      @infected_user.user_location_histories
                    .where(check_in: contagious_period)
                    .map(&:location)
                    .append(@infected_user.user_location&.location)
                    .compact
                    .uniq
    end

    def contagious_period
      initial_date = test_date - PERIOD_OF_CONTAGIOUS_DAYS
      final_date = [test_date + PERIOD_OF_CONTAGIOUS_DAYS, Date.today].min
      initial_date.to_time..final_date.end_of_day
    end

    def test_date
      @test_date ||= @infected_user.covid_tests.positive.last.date
    end
  end
end