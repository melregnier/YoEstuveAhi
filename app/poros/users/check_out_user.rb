module Users
  class CheckOutUser
    def initialize(qr_tempfile, user)
      @qr_tempfile = qr_tempfile
      @user = user
    end
    
    def perform
      raise Errors::InvalidUserOperation unless @user.can_check_out?

      location_id = Qr::QrDecoder.new(@qr_tempfile.tempfile.to_path).perform.to_i
      raise Errors::LocationNotFound unless Location.exists?(location_id)
      
      raise Errors::InvalidUserOperation unless location_id == @user.user_location.location.id

      ActiveRecord::Base.transaction do
        @user.user_location_histories.create!(
          check_in: @user.user_location.check_in,
          check_out: Time.now,
          location_id: location_id
        )
        @user.user_location.destroy!
      end

      Users::InformInContactUsersOfPossibleRisk.new(@user).perform if @user.infected?
    end
  end
end