class NotifyUserOfPossibleRisk
  def initialize(user)
    @user = user
  end

  def perform
    UserMailer.with(user: @user).at_risk_email.deliver_now
    # TO DO: COSAS DE NOTIFICACION
  end
end