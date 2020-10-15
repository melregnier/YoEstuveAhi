class UserMailer < ApplicationMailer
  DAYS_TO_BE_HEALTHY = Rails.application.secrets.days_to_be_healthy
  
  def welcome_email
    @user = params[:user]
    mail(to: @user.email, subject: 'Bienvenido')
  end

  def at_risk_email
    @user = params[:user]
    @days_to_be_healthy = DAYS_TO_BE_HEALTHY
    mail(to: @user.email, subject: 'Riesgo de contagio')
  end

  def location_at_risk_email
    @user = params[:user]
    mail(to: @user.email, subject: 'Riesgo de contagio')
  end
end