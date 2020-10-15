class CovidTest < ApplicationRecord
  belongs_to :user
  validate :date_not_in_future

  scope :positive, -> { where(result: true) }
  scope :negative, -> { where(result: false) }

  private

  def date_not_in_future
    errors.add(:date, 'No podés registrar un test en el futuro') if date.future?
  end
end
