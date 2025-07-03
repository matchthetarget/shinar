Rails.application.routes.draw do
  devise_for :admins
  root to: "chats#index"

  # Analytics dashboard (admin only)
  authenticate :admin do
    mount Blazer::Engine, at: "blazer"
  end

  resources :metrics, only: [ :index ]

  resources :configurations, only: [] do
    get :android_v1, on: :collection
    get :ios_v1, on: :collection
  end

  resources :chat_users
  resources :chats, param: :token do
    resources :messages
    member do
      get "qr"
      get "members"
    end
  end
  resources :users do
    collection do
      get :edit
    end

    member do
      delete :sign_out
    end
  end

  resources :notification_tokens, only: :create
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", :as => :rails_health_check
  get "about" => "pages#about", :as => :about
  get "privacy_policy" => "pages#privacy_policy", :as => :privacy_policy
  get "terms_of_service" => "pages#terms_of_service", :as => :terms_of_service


  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"
end
