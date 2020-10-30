module Users
  class DischargeUser
    def initialize(user, date)
      @user = user
      @date = date
    end

    def perform
      ActiveRecord::Base.transaction do 
        @user.covid_tests.create!(date: @date, result: false)
        @user.discharge
      rescue => error
        raise Errors::InvalidTest.new
      end
    end
  end
end