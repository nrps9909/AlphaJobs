class Company
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name, type: String
  field :description, type: String

  has_many :jobs, dependent: :destroy

  validates :name, presence: true, uniqueness: true

  def average_salary
    return 0 if jobs.empty?
    
    total = jobs.sum do |job|
      (job.min_salary + job.max_salary) / 2.0
    end
    
    (total / jobs.count).round
  end

  def high_salary_jobs_count
    jobs.where(:min_salary.gte => 100000).count
  end
end
