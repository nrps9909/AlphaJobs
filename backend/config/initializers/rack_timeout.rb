# backend/config/initializers/rack_timeout.rb
if defined?(Rack::Timeout) && Rails.env.production?
  timeout_value = ENV.fetch('RACK_SERVICE_TIMEOUT_SECONDS', 20).to_i

  if Rack::Timeout.respond_to?(:service_timeout=)
    # For rack-timeout 0.6.0+
    Rack::Timeout.service_timeout = timeout_value
    Rails.logger.info "[INFO] Rack::Timeout configured with service_timeout: #{Rack::Timeout.service_timeout} seconds (version >= 0.6.0)." if defined?(Rails.logger)
  elsif Rack::Timeout.respond_to?(:timeout=)
    # For rack-timeout < 0.6.0 (e.g., 0.5.x)
    Rack::Timeout.timeout = timeout_value
    Rails.logger.info "[INFO] Rack::Timeout configured with timeout: #{Rack::Timeout.timeout} seconds (version < 0.6.0)." if defined?(Rails.logger)
  else
    Rails.logger.warn "[WARN] Rack::Timeout is defined, but neither service_timeout= nor timeout= methods are available. Timeout not configured." if defined?(Rails.logger)
  end

  # 您也可以在這裡打印 Rack::Timeout::VERSION 來確認版本
  if defined?(Rack::Timeout::VERSION) && defined?(Rails.logger)
    Rails.logger.info "[INFO] Rack::Timeout gem version: #{Rack::Timeout::VERSION}"
  end

elsif defined?(Rack::Timeout) && !Rails.env.production? && defined?(Rails.logger)
  Rails.logger.info "[INFO] Rack::Timeout loaded but not configured for non-production env: #{Rails.env}."
elsif defined?(Rails.logger)
  Rails.logger.warn "[WARN] Rack::Timeout is not defined. Timeout middleware will not be configured."
end