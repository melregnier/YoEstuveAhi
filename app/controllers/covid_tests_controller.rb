class CovidTestsController < ApplicationController
  def index
    @decorated_tests = current_user.covid_tests.order(date: :desc).map do |test|
      CovidTestDecorator.new(test)
    end
  end

  def new_positive
    @positive_test = CovidTest.new
  end

  def new_negative
    @negative_test = CovidTest.new
  end

  def create_positive
    Users::GetUserInfected.new(current_user, date).perform
    flash[:notice] = 'Test registrado correctamente'
    redirect_to('/home')
  end

  def create_negative
    Users::DischargeUser.new(current_user, date).perform
    flash[:notice] = 'Test registrado correctamente'
    redirect_to('/home')
  end

  private

  def date
    params.require(:covid_test)[:date].to_date
  end
end