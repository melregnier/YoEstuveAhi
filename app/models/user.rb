class User < ApplicationRecord
  has_one :user_location
  has_many :covid_tests
  has_many :user_location_histories
  has_many :locations

  has_secure_password

  validates_presence_of :name, :document_type, :document_number, :password_digest, :email, :state

  validates_uniqueness_of :email

  validates_confirmation_of :password

  STATE_MAP = {
    'healthy' => HealthyState,
    'at_risk' => AtRiskState,
    'infected' => InfectedState
  }

  enum state: {
    healthy: 'healthy',
    at_risk: 'at_risk',
    infected: 'infected'
  }

  def can_check_in?
    user_location.nil? && state_object.can_check_in?
  end
  
  def can_check_out?
    user_location.present?
  end

  def respond_to?(method_name)
    state_object.respond_to?(method_name) || super
  end

  def method_missing(method_name, *args)
    return state_object.send(method_name, *args) if state_object.respond_to?(method_name)
  
    super
  end

  private

  def state_object
    STATE_MAP[self.state].new(self)
  end
end
