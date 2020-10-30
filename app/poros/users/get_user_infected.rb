module Users
  class GetUserInfected
    def initialize(user, date)
      @user = user
      @date = date
    end

    def perform
      raise Errors::InvalidTest unless @user.can_get_infected?

      ActiveRecord::Base.transaction do
        @user.covid_tests.create!(date: @date, result: true)
        @user.got_infected
      rescue => error
        raise Errors::InvalidTest
      end

      Notifications::NotifyLocationsOfInfection.new(@user).perform
      Users::InformInContactUsersOfPossibleRisk.new(@user).perform unless @user.user_location.present?
    end
  end
end