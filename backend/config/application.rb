require_relative "boot"

require "logger" # <--- ADDED THIS LINE

require "rails"
require "active_model/railtie"
require "active_job/railtie"
require "action_controller/railtie"
require "action_view/railtie"
require "action_cable/railtie"
require "rails/test_unit/railtie"

Bundler.require(*Rails.groups)

module JobPortal
  class Application < Rails::Application
    config.load_defaults 7.0
    config.api_only = true

    # 添加 logger
    config.logger = ActiveSupport::Logger.new(STDOUT)

    config.middleware.insert_before 0, Rack::Cors do
      allow do
        origins '*'
        resource '*',
          headers: :any,
          methods: [:get, :post, :put, :patch, :delete, :options, :head]
      end
    end
  end
end
