class CovidTest < ApplicationRecord
  belongs_to :user
  validate :date_not_in_future
  validate :date_after_last_test

  scope :positive, -> { where(result: true) }
  scope :negative, -> { where(result: false) }

  private

  def date_not_in_future
    errors.add(:date, 'No podés registrar un test en el futuro') if date.future?
  end

  def date_after_last_test
    errors.add(:date, 'El test que intenta registrar tiene una fecha previa al ultimo test registrado.') unless user.covid_tests.empty? || user.covid_tests.last.date <= date
  end
end
