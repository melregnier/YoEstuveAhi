module Users
  class CheckInUser
    RUBY_SERVER_ID = Rails.application.secrets.ruby_server_id

    def initialize(qr_tempfile, user)
      @qr_tempfile = qr_tempfile
      @user = user
    end

    def perform
      raise Errors::InvalidUserOperation unless @user.can_check_in?

      location_data = Qr::QrDecoder.new(@qr_tempfile.tempfile.to_path).perform
      location_id = location_data['location_id']
      server_id = location_data['server_id']

      if server_id == RUBY_SERVER_ID do
        raise Errors::LocationNotFound unless Location.exists?(location_id)
        
        location = Location.find(location_id)
        raise Errors::LocationFull if location.full?
        
        #aumentar la concurrencia en transaccion con lo de abajo
        @user.create_user_location!(location_id: location_id.to_i, check_in: Time.now)
      else 
        # llamar al modulo cqqsl que se comica con las otras apis para obtener la info de la locacion y si no esta la creamos
        # hacer check in en el externo
        # si da success crea la user location
        external_service = ExternalServices::ExternalApiService.new(server_id)
        external_location_data = external_service.location_data(location_id)
        location = Location.find_or_create_by(external_id: location_id, server_id: server_id) do | location |
          location.latitude = external_location_data['latitude']
          location.longitude = external_location_data['longitude']
          location.capacity = external_location_data['capacity']
        end

        raise Errors::LocationFull if external_location_data['capacity'] <= external_location_data['concurrence']
        
        external_service.check_in(location_id)
        
        @user.create_user_location!(location_id: location.id, check_in: Time.now)
      end
    end
  end
end