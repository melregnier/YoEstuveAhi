class Location < ApplicationRecord
  belongs_to :user
  has_many :user_locations
  has_many :user_location_histories

  validates_presence_of :name, :capacity, :latitude, :longitude, :user_id
end
