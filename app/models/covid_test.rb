class CovidTest < ApplicationRecord
  belongs_to :user

  scope :positive, where(result: true)
  scope :negative, where(result: false)
end
