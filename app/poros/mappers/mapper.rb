module Mappers
  class Mapper
    MAP_OPTIONS = {
      stay: {
        user_location_history: :from_stay_to_ulh
      },
      user_location_history: {
        stay: :from_ulh_to_stay
      }
    }

    def initialize(object, options)
      @from = options[:from]
      @to = options[:to]
      @object = object
    end

    def perform
      send(MAP_OPTIONS[@from][@to])
    end

    def from_stay_to_ulh
      location = Location.find_by(external_id: @object[:location_id].to_i, server_id: @object[:server_id].to_i)
      return nil if location.nil?

      {
        location_id: location.id,
        check_in: @object[:begin].to_time,
        check_out: @object[:end].to_time
      }
    end

    def from_ulh_to_stay
      { 
        location_id: @object.location.external_id, 
        server_id: @object.location.server_id, 
        begin: @object.check_in, 
        end: @object.check_out
      }
    end
  end
end
