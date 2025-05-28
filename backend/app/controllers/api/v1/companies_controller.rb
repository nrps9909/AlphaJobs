module Api
  module V1
    class CompaniesController < ApplicationController
      def statistics
        Rails.logger.info "====== CompaniesController#statistics ======" # 添加日誌
        companies = Company.includes(:jobs).all
        Rails.logger.info "Found #{companies.count} companies from DB." # 添加日誌
        companies.each_with_index do |company, index| # 添加日誌
          Rails.logger.info "Company ##{index}: ID: #{company.id}, Name: #{company.name}, Jobs count: #{company.jobs.count}, Avg Salary: #{company.average_salary}, High Salary Jobs: #{company.high_salary_jobs_count}"
        end

        stats = companies.map do |company|
          {
            id: company.id.to_s,
            name: company.name,
            average_salary: company.average_salary,
            high_salary_jobs_count: company.high_salary_jobs_count
          }
        end
        Rails.logger.info "Generated stats data (first 2 shown if any): #{stats.first(2).inspect}" # 添加日誌，只顯示部分以避免日誌過長
        Rails.logger.info "Total stats items: #{stats.length}" # 添加日誌
        Rails.logger.info "==========================================" # 添加日誌
        render json: stats
      end
    end
  end
end