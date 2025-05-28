module Api
  module V1
    class JobsController < ApplicationController
      def index
        @jobs = Job.includes(:company).all
        render json: format_jobs(@jobs)
      end

      def search
        keyword = params[:keyword]
        @jobs = Job.includes(:company).where(title: /#{keyword}/i)
        render json: format_jobs(@jobs)
      end

      private

      def format_jobs(jobs)
        jobs.map do |job|
          {
            id: job.id.to_s,
            title: job.title,
            description: job.description,
            min_salary: job.min_salary,
            max_salary: job.max_salary,
            company: {
              id: job.company.id.to_s,
              name: job.company.name
            }
          }
        end
      end
    end
  end
end
