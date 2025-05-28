module Api
  module V1
    class HealthController < ApplicationController
      def show
        # 基本健康檢查
        health_status = {
          status: 'ok',
          timestamp: Time.current.iso8601,
          rails_env: Rails.env
        }

        # 檢查 MongoDB 連線（但不讓它導致健康檢查失敗）
        begin
          Mongoid.default_client.database.command(ping: 1)
          health_status[:database] = 'connected'
        rescue => e
          health_status[:database] = 'disconnected'
          health_status[:database_error] = e.message if Rails.env.development?
        end

        render json: health_status
      end
    end
  end
end