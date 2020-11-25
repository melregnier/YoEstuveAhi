class Location < ApplicationRecord
  belongs_to :user
  has_many :user_locations
  has_many :user_location_histories
  has_one_attached :location_image
  geocoded_by :address
  after_initialize :geocode

  validates_presence_of :name, :capacity, :latitude, :longitude, :user_id

  def full?
    concurrence >= capacity
  end

  def address
    [street, street_number, zip_code, country].join(' ')
  end

  def as_json(*)
    super.merge({
      "address" => address,
      "users_count" => user_locations.count
    })
  end
end