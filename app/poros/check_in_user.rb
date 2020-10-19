class CheckInUser
  def initialize(qr_tempfile, user)
    @qr_tempfile = qr_tempfile
    @user = user
  end

  def perform
    raise Errors::InvalidUserOperation unless @user.can_check_in?

    location_id = QrDecoder.new(@qr_tempfile.tempfile.to_path).perform.to_i
    raise Errors::LocationNotFound unless Location.exists?(location_id)
    
    raise Errors::LocationFull if location.full?
    current_user.user_location.create!(location_id: location_id.to_i, check_in: Time.now)
  end
end