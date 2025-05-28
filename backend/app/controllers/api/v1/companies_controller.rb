module Api
  module V1
    class CompaniesController < ApplicationController
      def statistics
        companies = Company.includes(:jobs).all
        
        stats = companies.map do |company|
          {
            id: company.id.to_s,
            name: company.name,
            average_salary: company.average_salary,
            high_salary_jobs_count: company.high_salary_jobs_count
          }
        end
        
        render json: stats
      end
    end
  end
end
