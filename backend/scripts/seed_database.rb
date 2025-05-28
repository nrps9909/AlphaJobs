require 'json'

# 讀取 JSON 檔案
file_path = Rails.root.join('..', 'data', 'jobs_data.json')
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

puts "資料庫初始化完成！"
puts "公司數量: #{Company.count}"
puts "職缺數量: #{Job.count}"
