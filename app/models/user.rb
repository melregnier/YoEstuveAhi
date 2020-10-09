class User < ApplicationRecord
    enum status: {
        healthy: 'healthy',
        at_risk: 'at_risk',
        infected: 'infected'
    }
end
