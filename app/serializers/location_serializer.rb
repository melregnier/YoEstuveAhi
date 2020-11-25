class LocationSerializer < ActiveModel::Serializer
  attributes :name, :concurrence, :capacity, :latitude, :longitude
end
