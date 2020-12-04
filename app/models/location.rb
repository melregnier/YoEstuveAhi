class Location < ApplicationRecord
  RUBY_SERVER_ID = Rails.application.secrets.ruby_server_id

  belongs_to :user, optional: true
  has_many :user_locations
  has_many :user_location_histories
  has_one_attached :location_image
  geocoded_by :address
  after_initialize :geocode
  after_save :fill_external_fields

  validates_presence_of :name, :capacity, :latitude, :longitude, :concurrence

  def full?
    concurrence >= capacity
  end

  def address
    [street, street_number, zip_code, country].join(' ')
  end

  def as_json(*)
    super.merge({
      "address" => address,
      "users_count" => concurrence
    })
  end

  def fill_external_fields
    update(server_id: RUBY_SERVER_ID, external_id: id) if external_id.nil?
  end
end