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
    'healthy' => HealthyState.instance,
    'at_risk' => AtRiskState.instance,
    'infected' => InfectedState.instance
  }

  enum state: {
    healthy: 'healthy',
    at_risk: 'at_risk',
    infected: 'infected'
  }

  def method_missing(method_name, *args)
    return state_object.send(method_name, *args) if state_object.respond_to?(method_name)
  
    super
  end

  private

  def state_object
    STATE_MAP[self.state]
  end
end
