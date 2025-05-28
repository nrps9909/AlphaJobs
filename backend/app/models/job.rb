class Job
  include Mongoid::Document
  include Mongoid::Timestamps

  field :title, type: String
  field :description, type: String
  field :min_salary, type: Integer
  field :max_salary, type: Integer

  belongs_to :company

  validates :title, presence: true
  validates :min_salary, :max_salary, presence: true, numericality: { greater_than: 0 }
  validate :salary_range_valid

  index({ title: 'text' })
  index({ company_id: 1 })

  private

  def salary_range_valid
    if min_salary && max_salary && min_salary > max_salary
      errors.add(:max_salary, "must be greater than or equal to minimum salary")
    end
  end
end
