# config/initializers/mongoid_log_level.rb
if Rails.env.production? # 或者針對所有環境進行偵錯
  Mongo::Logger.logger.level = ::Logger::DEBUG
end