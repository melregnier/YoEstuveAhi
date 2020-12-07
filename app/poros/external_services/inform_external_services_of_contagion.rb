module ExternalServices
  class InformExternalServicesOfContagion 
    # if more servers are added this should be modified
    EXTERNAL_SERVERS_ID = [Rails.application.secrets.react_server_id, Rails.application.secrets.asp_server_id]

    def initialize(user_location_histories)
      @user_location_histories = user_location_histories
    end
  
    def perform
      formatted_stays = @user_location_histories.map do | user_location_history |
        Mappers::Mapper.new(user_location_history, from: :user_location_history, to: :stay).perform
      end
      stays_body = { stays: formatted_stays }.to_json

      EXTERNAL_SERVERS_ID.each do | server_id |
        ExternalServices::ExternalApiService.new(server_id).notify_contagion(stays_body)
      end
    end
  end
end
