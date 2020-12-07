module Users
  class CheckOutUser
    RUBY_SERVER_ID = Rails.application.secrets.ruby_server_id
    attr_reader :location_id , :server_id

    def initialize(qr_tempfile, user)
      @qr_tempfile = qr_tempfile
      @user = user
    end
    
    def perform
      raise Errors::InvalidUserOperation unless @user.can_check_out?
      
      location_data = Qr::QrDecoder.new(@qr_tempfile.tempfile.to_path).perform
      @location_id = location_data['location_id'].to_i
      @server_id = location_data['server_id'].to_i
      
      raise Errors::LocationNotFound unless Location.exists?(external_id: location_id)
      
      raise Errors::InvalidUserOperation unless location_id == @user.user_location.location.id
      
      server_id == RUBY_SERVER_ID ? internal_check_out : external_check_out
      Users::InformInContactUsersOfPossibleRisk.new(@user).perform if @user.infected?
    end

    private

    def internal_check_out
      ActiveRecord::Base.transaction do
        @user.user_location_histories.create!(
          check_in: @user.user_location.check_in,
          check_out: Time.zone.now,
          location_id: location_id
        )
        @user.user_location.location.update!(concurrence: @user.user_location.location.concurrence - 1)
        @user.user_location.destroy!
      end
    end

    def external_check_out
      external_service = ExternalServices::ExternalApiService.new(server_id)
      external_service.check_out(location_id)

      ActiveRecord::Base.transaction do
        @user.user_location_histories.create!(
          check_in: @user.user_location.check_in,
          check_out: Time.zone.now,
          location_id: location_id
        )
        @user.user_location.destroy!
      end
    end
  end
end