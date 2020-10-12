# This file is used by Rack-based servers to start the application.

require_relative 'config/environment'

require 'require_all'

require_all 'app'

require 'delegate'

run Rails.application
