Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
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
    end
  end
  
  post 'api/v1/seed', to: 'api/v1/seed#create'
end
