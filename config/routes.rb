Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  namespace :admin do
    root to: 'dashboard#index'
    resources :task_types, except: [:show] do
      collection do
        get 'database_view'
      end
    end
    resources :cycles, only: [:new, :create, :index]
  end

  resources :task_instances, only: [:index, :update]

  root to: 'task_instances#index'
end
