namespace :db do
  namespace :mongoid do
    desc "Safely create indexes with error handling"
    task safe_create_indexes: :environment do
      begin
        Rails.logger.info "Attempting to create indexes..."
        
        # 測試連線
        Mongoid.default_client.database_names
        Rails.logger.info "MongoDB connection successful"
        
        # 創建索引
        Rails.application.eager_load!
        
        created_indexes = []
        failed_indexes = []
        
        Mongoid.models.each do |model|
          next unless model.index_specifications.any?
          
          begin
            model.create_indexes
            created_indexes << model.name
            Rails.logger.info "Created indexes for #{model.name}"
          rescue => e
            failed_indexes << { model: model.name, error: e.message }
            Rails.logger.error "Failed to create indexes for #{model.name}: #{e.message}"
          end
        end
        
        Rails.logger.info "Index creation completed. Created: #{created_indexes.count}, Failed: #{failed_indexes.count}"
        
        # 如果有失敗但不是全部失敗，視為部分成功
        if failed_indexes.any? && created_indexes.any?
          Rails.logger.warn "Some indexes failed to create, but continuing..."
          exit 0
        elsif failed_indexes.any? && created_indexes.empty?
          Rails.logger.error "All index creation failed"
          exit 1
        else
          Rails.logger.info "All indexes created successfully"
          exit 0
        end
        
      rescue Mongo::Auth::Unauthorized => e
        Rails.logger.error "MongoDB Authentication failed: #{e.message}"
        Rails.logger.error "Please check your MONGODB_URI and ensure the user has proper permissions"
        # 在 Heroku release 階段，我們不想因為索引創建失敗而阻止部署
        exit 0
      rescue => e
        Rails.logger.error "Unexpected error during index creation: #{e.class} - #{e.message}"
        Rails.logger.error e.backtrace.join("\n")
        exit 0
      end
    end
  end
end