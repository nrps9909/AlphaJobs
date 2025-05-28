module Api
  module V1
    class SeedController < ApplicationController
      def create
        # 讀取 JSON 檔案
        file_path = Rails.root.join('data', 'jobs_data.json')
        
        if File.exist?(file_path)
          data = JSON.parse(File.read(file_path))
          
          # 清空現有資料
          Job.destroy_all
          Company.destroy_all
          
          # 建立公司和職缺
          data['companies'].each do |company_data|
            company = Company.create!(
              name: company_data['name'],
              description: company_data['description']
            )
            
            company_data['jobs'].each do |job_data|
              company.jobs.create!(
                title: job_data['title'],
                description: job_data['description'],
                min_salary: job_data['min_salary'],
                max_salary: job_data['max_salary']
              )
            end
          end
          
          render json: { message: 'Database seeded successfully' }, status: :created
        else
          render json: { error: 'Seed file not found' }, status: :not_found
        end
      end
    end
  end
end
