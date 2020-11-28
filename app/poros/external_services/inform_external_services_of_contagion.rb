module ExternalServices
  class InformExternalServicesOfContagion 
    # if more servers are added this should be modified
    EXTERNAL_SERVERS_ID = [Rails.application.secrets.react_server_id, Rails.application.secrets.asp_server_id]

    def initialize(user_location_histories)
      @user_location_histories = user_location_histories
    end
  
    def perform
      formatted_stays = @user_location_histories.map do | user_location_history |
        { 
          location_id: user_location_history.location.external_id, 
          server_id: user_location_history.location.server_id, 
          begin: user_location_history.check_in, 
          end: user_location_history.check_out
        }
      end
      stays_body = { stays: formatted_stays }.to_json

      EXTERNAL_SERVERS_ID.each do | server_id | 
        ExternalServices::ExternalApiService.new(server_id).notify_contagion(stays_body)
      end
    end
  end
end