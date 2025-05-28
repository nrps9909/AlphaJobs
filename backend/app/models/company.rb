# backend/app/models/company.rb
class Company
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name, type: String
  field :description, type: String

  has_many :jobs, dependent: :destroy

  validates :name, presence: true, uniqueness: true

  # 舊的 average_salary 和 high_salary_jobs_count 方法可以保留用於單個實例，
  # 但統計接口將使用下面的聚合方法。

  # 使用聚合框架獲取所有公司的統計數據
  def self.all_statistics
    # 直接使用 Job model 的 collection name，通常是 model 名稱的小寫複數形式 "jobs"
    # 如果您的 Job model collection 名稱不同，請修改這裡
    job_collection_name = Job.collection.name

    aggregation_pipeline = [
      {
        '$lookup': {
          from: job_collection_name, # 要連接的 collection (Jobs)
          localField: '_id',        # Company collection 中的字段
          foreignField: 'company_id', # Job collection 中的字段
          as: 'jobs_for_company'     # 將匹配的 jobs 放入這個陣列字段
        }
      },
      {
        '$addFields': { # 添加計算字段，而不是立即 $unwind，以處理沒有職缺的公司
          calculated_jobs_data: {
            '$map': { # 遍歷 jobs_for_company 陣列
              input: '$jobs_for_company',
              as: 'job',
              in: {
                avg_salary_contribution: { # 計算 (min_salary + max_salary) / 2
                  '$divide': [
                    { '$add': ['$$job.min_salary', '$$job.max_salary'] },
                    2.0
                  ]
                },
                is_high_salary: { # 判斷是否為高薪職缺
                  '$gte': ['$$job.min_salary', 100000]
                }
              }
            }
          }
        }
      },
      {
        '$project': { # 選擇並重塑輸出字段
          _id: 1, # 保留 company id
          name: 1, # 保留 company name
          average_salary: {
            '$cond': { # 條件判斷
              if: { '$eq': [{ '$size': '$calculated_jobs_data' }, 0] }, # 如果職缺數量為 0
              then: 0, # 平均薪資為 0
              else: { # 否則計算平均薪資
                '$round': [ # 四捨五入
                  { '$avg': '$calculated_jobs_data.avg_salary_contribution' }
                ]
              }
            }
          },
          high_salary_jobs_count: {
            '$size': { # 計算高薪職缺的數量
              '$filter': { # 過濾出 is_high_salary 為 true 的項
                input: '$calculated_jobs_data',
                as: 'job_data',
                cond: '$$job_data.is_high_salary'
              }
            }
          }
        }
      },
      {
        '$sort': { name: 1 } # 按公司名稱排序 (可選)
      }
    ]

    # 執行聚合查詢
    # Mongoid 7+ 可以直接在 Model 上調用 .collection.aggregate
    # 如果是舊版 Mongoid，可能需要 Mongoid.default_client.database[collection_name].aggregate
    Company.collection.aggregate(aggregation_pipeline).to_a
  end

  # 為了單個 Company 實例，如果仍然需要這些方法，可以保留它們，
  # 但要注意它們可能不如聚合查詢高效。
  def average_salary
    return 0 if jobs.empty?
    total = jobs.sum { |job| (job.min_salary + job.max_salary) / 2.0 }
    (total / jobs.count).round
  end

  def high_salary_jobs_count
    jobs.where(:min_salary.gte => 100000).count
  end
end