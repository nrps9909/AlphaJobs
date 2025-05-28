Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      # 健康檢查端點
      get 'health', to: 'health#show'
      
      resources :jobs, only: [:index] do
        collection do
          get 'search'
        end
      end
      
      resources :companies, only: [] do
        collection do
          get 'statistics'
        end
      end
      
      post 'seed', to: 'seed#create'
    end
  end
end