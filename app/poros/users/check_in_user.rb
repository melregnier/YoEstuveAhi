module Users
  class CheckInUser
    RUBY_SERVER_ID = Rails.application.secrets.ruby_server_id
    attr_reader :location_id , :server_id

    def initialize(qr_tempfile, user)
      @qr_tempfile = qr_tempfile
      @user = user
    end

    def perform
      raise Errors::InvalidUserOperation unless @user.can_check_in?

      location_data = Qr::QrDecoder.new(@qr_tempfile.tempfile.to_path).perform
      @location_id = location_data['location_id'].to_i
      @server_id = location_data['server_id'].to_i

      server_id == RUBY_SERVER_ID ? internal_check_in : external_check_in
    end
    
    private
    
    def internal_check_in
      raise Errors::LocationNotFound unless Location.exists?(location_id)
      
      location = Location.find(location_id)
      raise Errors::LocationFull if location.full?

      ActiveRecord::Base.transaction do
        @user.create_user_location!(location_id: location_id, check_in: Time.zone.now)
        location.update!(concurrence: location.concurrence + 1)
      end
    end
    
    def external_check_in
      external_service = ExternalServices::ExternalApiService.new(server_id)
      # fetch location data
      external_location_data = external_service.location_data(location_id)
      # create if necessary external location
      location = Location.find_or_create_by(external_id: location_id, server_id: server_id) do | location |
        location.latitude = external_location_data['latitude']
        location.longitude = external_location_data['longitude']
        location.capacity = external_location_data['capacity']
      end
      
      raise Errors::LocationFull if external_location_data['capacity'] <= external_location_data['concurrence']
      
      # let the server know of check in and create user_location
      external_service.check_in(location_id)
      
      @user.create_user_location!(location_id: location.id, check_in: Time.zone.now)
    end
  end
end
