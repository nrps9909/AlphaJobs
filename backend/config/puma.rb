# backend/config/puma.rb

# Puma 配置檔案

# 線程數配置
max_threads_count = ENV.fetch("RAILS_MAX_THREADS", 5).to_i
min_threads_count = ENV.fetch("RAILS_MIN_THREADS") { max_threads_count }.to_i
threads min_threads_count, max_threads_count

# 端口配置
port ENV.fetch("PORT", 3000)

# 環境配置
environment ENV.fetch("RAILS_ENV", "development")

# PID 檔案位置
pidfile ENV.fetch("PIDFILE", "tmp/pids/server.pid")

# Worker 數量（Heroku 免費方案建議使用 2-3 個 workers）
# 注意：如果 RAILS_MAX_THREADS 乘以 WEB_CONCURRENCY 超過資料庫連接池大小，可能會出問題。
# 對於免費的 Heroku dyno，通常 WEB_CONCURRENCY 設為 1 或 2，取決於您的記憶體使用。
# 如果 preload_app! 為 true，WEB_CONCURRENCY > 1 時可以節省記憶體。
workers ENV.fetch("WEB_CONCURRENCY", 1).to_i # 考慮到免費方案，預設為 1 個 worker 可能更穩定

# 使用 preload_app! 以節省記憶體 (如果是多 worker 模式)
# 如果 workers == 1，preload_app! 的效果不大，但無害。
preload_app!

# 允許 puma 重啟 (透過 tmp/restart.txt)
plugin :tmp_restart

# Worker 啟動前的設定 (僅在 workers > 0 時相關)
before_fork do
  # ActiveRecord 連線通常在這裡斷開，但您用的是 Mongoid
  # 所以我們斷開 Mongoid 連線
  if defined?(Mongoid)
    Mongoid.disconnect_clients
    Rails.logger.info('MongoDB connections disconnected before forking.') if defined?(Rails.logger)
  end

  # 如果您也用了 ActiveRecord (例如某些 gem 依賴)，也斷開它
  # defined?(ActiveRecord::Base) and ActiveRecord::Base.connection.disconnect!
end

# Worker 啟動後的設定 (僅在 workers > 0 時相關)
on_worker_boot do
  # ActiveRecord 連線通常在這裡重新建立
  # defined?(ActiveRecord::Base) and ActiveRecord::Base.establish_connection

  # 重新建立 Mongoid 連線
  if defined?(Mongoid)
    Mongoid::Clients.clients.each do |name, client|
      # 確保客戶端是可重連的類型
      if client.cluster.servers.any? && client.closed?
        begin
          client.reconnect
          Rails.logger.info("MongoDB client '#{name}' reconnected in worker.") if defined?(Rails.logger)
        rescue => e
          Rails.logger.error("Failed to reconnect MongoDB client '#{name}' in worker: #{e.message}") if defined?(Rails.logger)
        end
      elsif client.cluster.servers.empty?
        Rails.logger.warn("MongoDB client '#{name}' has no servers to reconnect to in worker.") if defined?(Rails.logger)
      end
    end
  end
end

# 如果您不使用 workers (即 WEB_CONCURRENCY=0 或 1)，
# Mongoid 的連接應該由 Rails 初始化過程處理，
# 上面的 before_fork 和 on_worker_boot 可能不會被執行或不是必需的。
# 但保留它們通常是安全的。

# 關於 rack-timeout 的配置已經移到 config/initializers/rack_timeout.rb
# 所以這裡不再需要相關的 require 和配置。