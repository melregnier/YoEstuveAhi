class Location < ApplicationRecord
  belongs_to :user
  has_many :user_locations
  has_many :user_location_histories
  has_one_attached :location_image

  validates_presence_of :name, :capacity, :latitude, :longitude, :user_id

  def full?
    user_locations.count >= capacity
  end
end
