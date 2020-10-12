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

  end

  def create_positive
    success = GetUserInfected.new(current_user, date).perform
    flash[:notice] = 'No se pudo registrar el test' unless success
    redirect_to('/home')
  end

  def create_negative
    
  end

  private

  def date
    params.require(:covid_test).permit(:date)
  end
end