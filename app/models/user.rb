class User < ApplicationRecord
    has_one :user_location
    has_many :covid_tests
    has_many :user_location_histories
    has_many :locations

    has_secure_password

    validates_presence_of :name, :document_type, :document_number, :password, :email, :status

    validates_uniqueness_of :email

    validates_confirmation_of :password

    enum status: {
        healthy: 'healthy',
        at_risk: 'at_risk',
        infected: 'infected'
    }
end
