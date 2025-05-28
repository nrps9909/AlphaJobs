require_relative "boot"

require "rails"

# 根據 API-only 的需求選擇性載入框架組件
require "active_model/railtie"
require "active_job/railtie"
require "action_controller/railtie"
# require "action_mailer/railtie"
# require "action_mailbox/engine"
# require "action_text/engine"
# require "action_view/railtie"
# require "action_cable/engine"

# 可以保留測試組件
require "rails/test_unit/railtie"

# Bundler.require 會載入 Gemfile 中的所有 gems，包括 mongoid 的核心
Bundler.require(*Rails.groups)

# 在 Bundler.require 之後載入 Mongoid Railtie
# 這樣可以確保 Mongoid 模組本身已經被定義
if defined?(Mongoid)
  require "mongoid/railtie"
end

module JobPortal
  class Application < Rails::Application
    config.load_defaults 7.0
    config.api_only = true

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
