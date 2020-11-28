class Location < ApplicationRecord
  RUBY_SERVER_ID = Rails.application.secrets.ruby_server_id

  belongs_to :user
  has_many :user_locations
  has_many :user_location_histories
  has_one_attached :location_image
  geocoded_by :address
  after_initialize :geocode
  after_save :fill_external_fields

  validates_presence_of :name, :capacity, :latitude, :longitude, :user_id, :concurrence

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

  def fill_external_fields
    update(server_id: RUBY_SERVER_ID, external_id: id) if external_id.nil?
  end
end