class UpdateAtRiskUsersWorker
  include Sidekiq::Worker
  DAYS_TO_BE_HEALTHY = Rails.application.secrets.days_to_be_healthy

  def perform
    users_to_update = User.at_risk.select do |user|
      user.user_logs.last.created_at + DAYS_TO_BE_HEALTHY.days <= Date.today
    end
    users_to_update.map(&:discharge)
  end
end