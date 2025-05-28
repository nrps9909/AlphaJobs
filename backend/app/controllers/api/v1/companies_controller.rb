# backend/app/controllers/api/v1/companies_controller.rb
module Api
  module V1
    class CompaniesController < ApplicationController
      def statistics
        Rails.logger.info "====== CompaniesController#statistics (using aggregation) ======" # 更新日誌訊息

        # 使用新的聚合方法獲取統計數據
        company_stats_from_db = Company.all_statistics

        # 格式化輸出以匹配前端期望的結構
        # 聚合結果中的 _id 是 BSON::ObjectId，需要轉換為字串
        # 字段名也可能需要調整 (例如 _id -> id)
        stats = company_stats_from_db.map do |data|
          {
            id: data['_id'].to_s, # 將 BSON::ObjectId 轉換為字串
            name: data['name'],
            average_salary: data['average_salary'].to_i, # 確保是整數
            high_salary_jobs_count: data['high_salary_jobs_count'].to_i # 確保是整數
          }
        end

        Rails.logger.info "Generated stats data using aggregation (first 2 shown if any): #{stats.first(2).inspect}"
        Rails.logger.info "Total stats items: #{stats.length}"
        Rails.logger.info "==================================================================="
        render json: stats
      end
    end
  end
end