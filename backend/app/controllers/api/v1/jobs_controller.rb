module Api
  module V1
    class JobsController < ApplicationController
      def index
        Rails.logger.info "========= JobsController#index =========" # 添加日誌
        @jobs = Job.includes(:company).all
        Rails.logger.info "Found #{@jobs.count} jobs from DB." # 添加日誌
        if @jobs.any? # 添加日誌
          Rails.logger.info "First job example: ID: #{@jobs.first.id}, Title: #{@jobs.first.title}, Company: #{@jobs.first.company&.name}"
        end

        formatted_jobs = format_jobs(@jobs)
        Rails.logger.info "Formatted jobs data (first 2 shown if any): #{formatted_jobs.first(2).inspect}" # 添加日誌，只顯示部分
        Rails.logger.info "Total formatted jobs: #{formatted_jobs.length}" # 添加日誌
        Rails.logger.info "========================================" # 添加日誌
        render json: formatted_jobs
      end

      def search
        Rails.logger.info "======== JobsController#search ========" # 添加日誌
        keyword = params[:keyword]
        Rails.logger.info "Search keyword: #{keyword}" # 添加日誌
        @jobs = Job.includes(:company).where(title: /#{keyword}/i)
        Rails.logger.info "Found #{@jobs.count} jobs from DB for keyword '#{keyword}'." # 添加日誌
        if @jobs.any? # 添加日誌
            Rails.logger.info "First search result example: ID: #{@jobs.first.id}, Title: #{@jobs.first.title}, Company: #{@jobs.first.company&.name}"
        end

        formatted_jobs = format_jobs(@jobs)
        Rails.logger.info "Formatted search results (first 2 shown if any): #{formatted_jobs.first(2).inspect}" # 添加日誌，只顯示部分
        Rails.logger.info "Total formatted search results: #{formatted_jobs.length}" # 添加日誌
        Rails.logger.info "========================================" # 添加日誌
        render json: formatted_jobs
      end

      private

      def format_jobs(jobs_list)
        return [] if jobs_list.nil? || jobs_list.empty?
        jobs_list.map do |job|
          {
            id: job.id.to_s,
            title: job.title,
            description: job.description,
            min_salary: job.min_salary,
            max_salary: job.max_salary,
            company: {
              id: job.company&.id.to_s,
              name: job.company&.name
            }
          }
        end
      end
    end
  end
end