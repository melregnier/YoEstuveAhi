module Notifications
  class NotifyUserOfPossibleRisk
    def initialize(user)
      @user = user
    end

    def perform
      UserMailer.with(user: @user).at_risk_email.deliver_now
      @user.user_notifications.create(message: 'Hemos registrado que ha tenido contacto con un usuario contagiado, su estado ha sido actualizado.')
    end
  end
end